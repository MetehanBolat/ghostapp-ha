output "storageName" {
    value = azurerm_storage_account.storage.name
}
output "storageKey" {
    value = azurerm_storage_account.storage.primary_access_key
}
output "shareName" {
    value = azurerm_storage_share.share.name
}
output "containerName" {
    value = azurerm_storage_share.share.name
}
output "sasKey" {
  value = data.azurerm_storage_account_sas.sas.sas
}
output "blobName" {
    value = azurerm_storage_blob.blob.name
}