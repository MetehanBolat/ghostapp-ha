provider "azurerm" {
  version = "=2.78.0"
  features {}
}

resource "azurerm_frontdoor" "waf" {
  name                                         = "${var.globalResourcePrefix}-waf"
  resource_group_name                          = var.rgName
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "defaultRule"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["endpoint01"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "endpoint01"
    }
  }

  backend_pool_load_balancing {
    name = "endpoint01"
  }

  backend_pool_health_probe {
    name = "endpoint01"
  }

  backend_pool {
    name = "endpoint01"
    backend {
      host_header = var.primaryUrl
      address     = var.primaryUrl
      http_port   = 80
      https_port  = 443
      weight      = 80
    }
    backend {
      host_header = var.secondaryUrl
      address     = var.secondaryUrl
      http_port   = 80
      https_port  = 443
      weight      = 20
    }

    load_balancing_name = "endpoint01"
    health_probe_name   = "endpoint01"
  }

  frontend_endpoint {
    name                                    = "endpoint01"
    host_name                               = "${var.globalResourcePrefix}-waf.azurefd.net"
    web_application_firewall_policy_link_id = azurerm_frontdoor_firewall_policy.wafPolicy.id
  }
}

resource "azurerm_frontdoor_firewall_policy" "wafPolicy" {
  name                              = "defaultPolicy"
  resource_group_name               = var.rgName
  enabled                           = true
  mode                              = "Prevention"
  redirect_url                      = "https://www.google.com"
  custom_block_response_status_code = 403
  custom_block_response_body        = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="

  custom_rule {
    name                           = "Rule01"
    enabled                        = true
    priority                       = 1
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
    type                           = "MatchRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
    }
  }

  custom_rule {
    name                           = "Rule02"
    enabled                        = true
    priority                       = 2
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 10
    type                           = "MatchRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["192.168.1.0/24"]
    }

    match_condition {
      match_variable     = "RequestHeader"
      selector           = "UserAgent"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["windows"]
      transforms         = ["Lowercase", "Trim"]
    }
  }

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"

    exclusion {
      match_variable = "QueryStringArgNames"
      operator       = "Equals"
      selector       = "not_suspicious"
    }

    override {
      rule_group_name = "PHP"

      rule {
        rule_id = "933100"
        enabled = false
        action  = "Block"
      }
    }

    override {
      rule_group_name = "SQLI"

      exclusion {
        match_variable = "QueryStringArgNames"
        operator       = "Equals"
        selector       = "really_not_suspicious"
      }

      rule {
        rule_id = "942200"
        action  = "Block"

        exclusion {
          match_variable = "QueryStringArgNames"
          operator       = "Equals"
          selector       = "innocent"
        }
      }
    }
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }
}