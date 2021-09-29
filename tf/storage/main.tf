provider "azurerm" {
  version = "=2.78.0"
  features {}
}
####################
## StorageAccount ##
####################
resource "azurerm_storage_account" "storage" {
  name                            = var.storageName
  resource_group_name             = var.rgName
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
}

####################
#### File Share ####
####################
resource "azurerm_storage_share" "share" {
    name                 = "ghost"
    storage_account_name = azurerm_storage_account.storage.name
    quota                = 50
    acl {
        id = "MzUzODIxODU3MzE1OTI3MzYxMzQwNDYwNTE4OTk2MDQ="
        access_policy {
            permissions = "rwdl"
            start       = "2021-09-28T06:00:00.0000000Z"
            expiry      = "2022-09-28T18:00:00.0000000Z"
        }
    }
}

####################
## Ghost specific ##
# Work Directories #
####################
#resource "azurerm_storage_share_directory" "adapters" {
#  name                 = "adapters"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}
#resource "azurerm_storage_share_directory" "apps" {
#  name                 = "apps"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}
#resource "azurerm_storage_share_directory" "data" {
#  name                 = "data"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}
#resource "azurerm_storage_share_directory" "images" {
#  name                 = "images"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}
#resource "azurerm_storage_share_directory" "logs" {
#  name                 = "logs"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}
#resource "azurerm_storage_share_directory" "settings" {
#  name                 = "settings"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}
#resource "azurerm_storage_share_directory" "themes" {
#  name                 = "themes"
#  share_name           = azurerm_storage_share.share.name
#  storage_account_name = azurerm_storage_account.storage.name
#}