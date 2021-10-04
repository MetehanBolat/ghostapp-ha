module "primary_rg" {
    source         = "./rg"
    resourcePrefix = var.primaryResourcePrefix
    location       = var.primaryLocation
}
module "secondary_rg" {
    source         = "./rg"
    resourcePrefix = var.secondaryResourcePrefix
    location       = var.secondaryLocation
}

## Geo-redundant storage
module "replicated_storage" {
    source         = "./storage"
    storageName    = var.storageName
    location       = var.primaryLocation
    rgName         = module.primary_rg.webrgname
}

module "replicated_db" {
    source         = "./db"
    resourcePrefix = var.primaryResourcePrefix
    location       = var.primaryLocation
    rgName         = module.primary_rg.dbrgname
    adminName      = var.adminName
    adminPass      = var.adminPass
}

module "primary_vault" {
    source         = "./vault"
    resourcePrefix = var.primaryResourcePrefix
    location       = var.primaryLocation
    rgName         = module.primary_rg.vaultrgname
    serverName     = module.replicated_db.serverName
    adminName      = var.adminName
    adminPass      = var.adminPass
}

module "secondary_vault" {
    source         = "./vault"
    resourcePrefix = var.secondaryResourcePrefix
    location       = var.secondaryLocation
    rgName         = module.secondary_rg.vaultrgname
    serverName     = module.replicated_db.serverName
    adminName      = var.adminName
    adminPass      = var.adminPass
}

module "primary_web" {
    source         = "./web"
    resourcePrefix = var.primaryResourcePrefix
    location       = var.primaryLocation
    rgName         = module.primary_rg.webrgname
    storageName    = module.replicated_storage.storageName
    storageKey     = module.replicated_storage.storageKey
    shareName      = module.replicated_storage.shareName
    containerName  = module.replicated_storage.containerName
    sasKey         = module.replicated_storage.sasKey
    blobName       = module.replicated_storage.blobName
    dbHost         = module.replicated_db.dbHost
    dbName         = module.replicated_db.dbName
    secretUriUser  = module.primary_vault.secretUriUser
    secretUriPass  = module.primary_vault.secretUriPass
    identity       = module.primary_vault.identityId
}
module "secondary_web" {
    source         = "./web"
    resourcePrefix = var.secondaryResourcePrefix
    location       = var.secondaryLocation
    rgName         = module.secondary_rg.webrgname
    storageName    = module.replicated_storage.storageName
    storageKey     = module.replicated_storage.storageKey
    shareName      = module.replicated_storage.shareName
    containerName  = module.replicated_storage.containerName
    sasKey         = module.replicated_storage.sasKey
    blobName       = module.replicated_storage.blobName
    dbHost         = module.replicated_db.dbHost
    dbName         = module.replicated_db.dbName
    secretUriUser  = module.secondary_vault.secretUriUser
    secretUriPass  = module.secondary_vault.secretUriPass
    identity       = module.secondary_vault.identityId
}

module "global_waf" {
    source = "./waf"
    globalResourcePrefix    = var.globalResourcePrefix
    primaryResourcePrefix   = var.primaryResourcePrefix
    secondaryResourcePrefix = var.secondaryResourcePrefix
    primaryLocation         = var.primaryLocation
    primaryUrl              = module.primary_web.url
    secondaryUrl            = module.secondary_web.url
}