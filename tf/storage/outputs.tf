output "storageName" {
    value = azurerm_storage_account.storage.name
}
output "storageKey" {
    value = azurerm_storage_account.storage.primary_access_key
}
output "shareName" {
    value = azurerm_storage_share.share.name
}

