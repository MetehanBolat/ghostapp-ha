provider "azurerm" {
  version = "=2.78.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.globalResourcePrefix}-rg"
  location = var.primaryLocation
}

resource "azurerm_frontdoor" "waf" {
  name                                         = "${var.globalResourcePrefix}-waf"
  resource_group_name                          = azurerm_resource_group.rg.name
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
    }
    backend {
      host_header = var.secondaryUrl
      address     = var.secondaryUrl
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "endpoint01"
    health_probe_name   = "endpoint01"
  }

  frontend_endpoint {
    name      = "endpoint01"
    host_name = "${var.globalResourcePrefix}-waf.azurefd.net"
  }
}