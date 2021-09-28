output "webrgname" {
    value = azurerm_resource_group.rgweb.name
}
output "dbrgname" {
    value = azurerm_resource_group.rgdb.name
}
output "webid" {
    value = azurerm_resource_group.rgweb.id
}
output "dbid" {
    value = azurerm_resource_group.rgdb.id
}