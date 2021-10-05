## Deploys all resource groups
module "rg" {
    source                  = "./rg"
    globalResourcePrefix    = var.globalResourcePrefix
    primaryResourcePrefix   = var.primaryResourcePrefix
    primaryLocation         = var.primaryLocation
    secondaryResourcePrefix = var.secondaryResourcePrefix
    secondaryLocation       = var.secondaryLocation
}

## Deploys Geo-redundant storage account, fileShare, container and functionApp artifact
module "storage" {
    source             = "./storage"
    storageName        = var.storageName
    location           = var.primaryLocation
    rgName             = module.rg.rgstorage
}

## Deploys HA MySQL Database with Geo-backup enabled
module "db" {
    source             = "./db"
    resourcePrefix     = var.primaryResourcePrefix
    location           = var.primaryLocation
    rgName             = module.rg.rgdb
    adminName          = var.adminName
    adminPass          = var.adminPass
}

##Deploys KeyVault service for primary location, user assigned identity with get-secret rights
module "primary_vault" {
    source             = "./vault"
    resourcePrefix     = var.primaryResourcePrefix
    location           = var.primaryLocation
    rgName             = module.rg.primary_rgvault
    serverName         = module.db.serverName
    adminName          = var.adminName
    adminPass          = var.adminPass
}
##Deploys KeyVault service for secondary location, user assigned identity with get-secret rights
module "secondary_vault" {
    source             = "./vault"
    resourcePrefix     = var.secondaryResourcePrefix
    location           = var.secondaryLocation
    rgName             = module.rg.secondary_rgvault
    serverName         = module.db.serverName
    adminName          = var.adminName
    adminPass          = var.adminPass
}

##Deploys application insights for primary location
module "primary_ai" {
    source             = "./ai"
    resourcePrefix     = var.primaryResourcePrefix
    location           = var.primaryLocation
    rgName             = module.rg.primary_rgweb
}
##Deploys application insights for secondary location
module "secondary_ai" {
    source             = "./ai"
    resourcePrefix     = var.secondaryResourcePrefix
    location           = var.secondaryLocation
    rgName             = module.rg.secondary_rgweb
}

##Deploys web applications and function app for primary location
module "primary_web" {
    source             = "./web"
    resourcePrefix     = var.primaryResourcePrefix
    location           = var.primaryLocation
    rgName             = module.rg.primary_rgweb
    storageName        = module.storage.storageName
    storageKey         = module.storage.storageKey
    shareName          = module.storage.shareName
    containerName      = module.storage.containerName
    sasKey             = module.storage.sasKey
    blobName           = module.storage.blobName
    dbHost             = module.db.dbHost
    dbName             = module.db.dbName
    secretUriUser      = module.primary_vault.secretUriUser
    secretUriPass      = module.primary_vault.secretUriPass
    identity           = module.primary_vault.identityId
    aiKey              = module.primary_ai.aiKey
    aiConnectionString = module.primary_ai.aiConnectionString
}
##Deploys web applications and function app for secondary location
module "secondary_web" {
    source             = "./web"
    resourcePrefix     = var.secondaryResourcePrefix
    location           = var.secondaryLocation
    rgName             = module.rg.secondary_rgweb
    storageName        = module.storage.storageName
    storageKey         = module.storage.storageKey
    shareName          = module.storage.shareName
    containerName      = module.storage.containerName
    sasKey             = module.storage.sasKey
    blobName           = module.storage.blobName
    dbHost             = module.db.dbHost
    dbName             = module.db.dbName
    secretUriUser      = module.secondary_vault.secretUriUser
    secretUriPass      = module.secondary_vault.secretUriPass
    identity           = module.secondary_vault.identityId
    aiKey              = module.secondary_ai.aiKey
    aiConnectionString = module.secondary_ai.aiConnectionString
}

##Deploys AzureFrontDoor service
module "global_waf" {
    source                  = "./waf"
    rgName                  = module.rg.rgwaf
    globalResourcePrefix    = var.globalResourcePrefix
    primaryUrl              = module.primary_web.url
    secondaryUrl            = module.secondary_web.url
}