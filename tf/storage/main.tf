provider "azurerm" {
  version = "=2.78.0"
  features {}
}
####################
## StorageAccount ##
####################
resource "azurerm_storage_account" "storage" {
  name                      = var.storageName
  resource_group_name       = var.rgName
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = true
  shared_access_key_enabled = true
  nfsv3_enabled             = false
  is_hns_enabled            = false
}
####################
#### File Share ####
####################
resource "azurerm_storage_share" "share" {
    name                 = "ghost"
    storage_account_name = azurerm_storage_account.storage.name
    quota                = 50
    acl {
        id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"
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