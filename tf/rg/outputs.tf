output "webrgname" {
    value = azurerm_resource_group.rgweb.name
}
output "dbrgname" {
    value = azurerm_resource_group.rgdb.name
}
output "vaultrgname" {
    value = azurerm_resource_group.rgvault.name
}
output "webid" {
    value = azurerm_resource_group.rgweb.id
}
output "dbid" {
    value = azurerm_resource_group.rgdb.id
}
output "vaultid" {
    value = azurerm_resource_group.rgvault.id
}