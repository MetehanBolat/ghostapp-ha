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
  access_tier               = "Hot"
  account_replication_type  = "GRS"
  
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
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
## Blob Container ##
####################
resource "azurerm_storage_container" "container" {
  name                  = "pub"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
####################
## Blob Artifacts ##
####################
resource "azurerm_storage_blob" "blob" {
  name                   = "ghost-function.zip"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "./storage/artifacts/ghost-function.zip"
  content_type           = "application/zip"
}

####################
##### SAS Key ######
####################
data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2021-10-01T00:00:00Z"
  expiry = "2022-10-01T00:00:00Z"

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = true
    add     = false
    create  = false
    update  = false
    process = false
  }
}