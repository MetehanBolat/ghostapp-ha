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

module "primary_storage" {
    source         = "./storage"
    storageName    = var.primaryStorageName
    location       = var.primaryLocation
    rgName         = module.primary_rg.webrgname
}
module "secondary_storage" {
    source         = "./storage"
    storageName    = var.secondaryStorageName
    location       = var.secondaryLocation
    rgName         = module.secondary_rg.webrgname
}

module "primary_db" {
    source         = "./db"
    resourcePrefix = var.primaryResourcePrefix
    location       = var.primaryLocation
    rgName         = module.primary_rg.dbrgname
    adminName      = var.adminName
    adminPass      = var.adminPass
}
module "secondary_db" {
    source         = "./db"
    resourcePrefix = var.secondaryResourcePrefix
    location       = var.secondaryLocation
    rgName         = module.secondary_rg.dbrgname
    adminName      = var.adminName
    adminPass      = var.adminPass
}

module "primary_web" {
    source         = "./web"
    resourcePrefix = var.primaryResourcePrefix
    location       = var.primaryLocation
    rgName         = module.primary_rg.webrgname
    storageName    = module.primary_storage.storageName
    storageKey     = module.primary_storage.storageKey
    shareName      = module.primary_storage.shareName
    dbHost         = module.primary_db.dbHost
    dbName         = module.primary_db.dbName
    dbUser         = module.primary_db.dbUser
    dbPass         = module.primary_db.dbPass
}
module "secondary_web" {
    source         = "./web"
    resourcePrefix = var.secondaryResourcePrefix
    location       = var.secondaryLocation
    rgName         = module.secondary_rg.webrgname
    storageName    = module.secondary_storage.storageName
    storageKey     = module.secondary_storage.storageKey
    shareName      = module.secondary_storage.shareName
    dbHost         = module.secondary_db.dbHost
    dbName         = module.secondary_db.dbName
    dbUser         = module.secondary_db.dbUser
    dbPass         = module.secondary_db.dbPass
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