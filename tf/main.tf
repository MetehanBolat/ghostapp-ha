module "rg" {
    source         = "./rg"
    resourcePrefix = var.resourcePrefix
    location       = var.location
}

module "storage" {
    source         = "./storage"
    storageName    = var.storageName
    location       = var.location
    rgName         = module.rg.webrgname
}

module "db" {
    source         = "./db"
    resourcePrefix = var.resourcePrefix
    location       = var.location
    rgName         = module.rg.dbrgname
    adminName      = var.adminName
    adminPass      = var.adminPass
}

module "web" {
    source         = "./web"
    resourcePrefix = var.resourcePrefix
    location       = var.location
    rgName         = module.rg.webrgname
    storageName    = module.storage.storageName
    storageKey     = module.storage.storageKey
    shareName      = module.storage.shareName
    dbHost         = module.db.dbHost
    dbName         = module.db.dbName
    dbUser         = module.db.dbUser
    dbPass         = module.db.dbPass
}