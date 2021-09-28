provider "azurerm" {
  version = "=2.78.0"
  features {}
}

####################
## AppServicePlan ##
####################
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.resourcePrefix}-asp"
  location            = var.location
  resource_group_name = var.rgName

  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

####################
#### WebApp for ####
#### Containers ####
####################
resource "azurerm_app_service" "app" {
  name                = "${var.resourcePrefix}-app"
  location            = var.location
  resource_group_name = var.rgName
  app_service_plan_id = "${azurerm_app_service_plan.asp.id}"

  storage_account {
    name         = var.storageName
    type         = "AzureFiles"
    account_name = var.storageName
    share_name   = var.shareName
    access_key   = var.storageKey
    mount_path   = "/var/lib/ghost/content"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    url                                 = "${var.resourcePrefix}-app.azurewebsites.net"
    database__client                    = "mysql"
    database__connection__host          = var.dbHost
    database__connection__port          = 3306
    database__connection__database      = var.dbName
    database__connection__user          = var.dbUser
    database__connection__password      = var.dbPass
  }

  site_config {
    linux_fx_version = "DOCKER|library/ghost:4.16.0-alpine"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}