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
### Function App ###
####################
resource "azurerm_function_app" "app" {
  name                       = "${var.resourcePrefix}-app"
  location                   = var.location
  resource_group_name        = var.rgName
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = var.storageName
  storage_account_access_key = var.storageKey
  os_type                    = "linux"

  app_settings = {
    DB_HOST                  = var.dbHost
    DB_DATABASE              = var.dbName
    DB_USER                  = "@Microsoft.KeyVault(VaultName=${var.vaultName};${var.secretNameUser})"
    DB_PASSWORD              = "@Microsoft.KeyVault(VaultName=${var.vaultName};${var.secretNamePass})"
    WEBSITE_RUN_FROM_PACKAGE = "https://${var.storageName}.blob.core.windows.net/${var.containerName}/${var.blobName}${var.sasKey}"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [var.identity]
  }
}

####################
#### WebApp for ####
#### Containers ####
####################
resource "azurerm_app_service" "web" {
  name                = "${var.resourcePrefix}-web"
  location            = var.location
  resource_group_name = var.rgName
  app_service_plan_id = azurerm_app_service_plan.asp.id

  storage_account {
    name         = var.storageName
    type         = "AzureFiles"
    account_name = var.storageName
    share_name   = var.shareName
    access_key   = var.storageKey
    mount_path   = "/var/lib/ghost/content"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE   = true ##required for storage persistance over Azure Files
    WEBSITES_CONTAINER_START_TIME_LIMIT   = 1000 ##ghost app requires time to boot up with mysql db connection. early restart causes database locks
    ## ghost settings
    url                                   = "https://${var.resourcePrefix}-web.azurewebsites.net"
    database__client                      = "mysql"
    database__connection__host            = var.dbHost
    database__connection__port            = 3306
    database__connection__database        = var.dbName
    database__connection__user            = "@Microsoft.KeyVault(VaultName=${var.vaultName};${var.secretNameUser})"
    database__connection__password        = "@Microsoft.KeyVault(VaultName=${var.vaultName};${var.secretNamePass})"
    database__connection__ssl             = "true"
    database__connection__ssl__minVersion = "TLSv1.2"
    NODE_ENV                              = "production"
    paths__contentPath                    = "/var/lib/ghost/content"
    WEBSITES_PORT                         = 2368
  }

  site_config {
    linux_fx_version = "DOCKER|ghost:4.16.0-alpine"
    always_on        = "true"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [var.identity]
  }
}


####################
# WebApp Autoscale #
####################
resource "azurerm_monitor_autoscale_setting" "asp" {
  name                = "default"
  resource_group_name = var.rgName
  location            = var.location
  target_resource_id  = azurerm_app_service_plan.asp.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 50
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.asp.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }  
}