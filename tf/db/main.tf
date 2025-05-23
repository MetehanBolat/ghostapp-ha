provider "azurerm" {
  version = "=2.78.0"
  features {}
}

####################
### MySQL Server ###
####################
resource "azurerm_mysql_server" "primaryServer" {
  name                = "${var.resourcePrefix}-db"
  location            = var.location
  resource_group_name = var.rgName

  administrator_login          = var.adminName
  administrator_login_password = var.adminPass

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

####################
## MySQL Database ##
####################
resource "azurerm_mysql_database" "mysqlDatabase" {
  name                = azurerm_mysql_server.primaryServer.name
  resource_group_name = azurerm_mysql_server.primaryServer.resource_group_name
  server_name         = azurerm_mysql_server.primaryServer.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "allowAzurePrimary" {
  name                = "allowAzure"
  resource_group_name = azurerm_mysql_server.primaryServer.resource_group_name
  server_name         = azurerm_mysql_server.primaryServer.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
### REMOVE ALLOW ALL and Allow only APP SERVICE PLAN IPs