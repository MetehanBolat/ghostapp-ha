output "rgname" {
    value = azurerm_resource_group.rg.name
}
output "webrgname" {
    value = azurerm_resource_group.rgweb.name
}
output "dbrgname" {
    value = azurerm_resource_group.rgdb.name
}
output "id" {
    value = azurerm_resource_group.rg.id
}
output "webid" {
    value = azurerm_resource_group.rgweb.id
}
output "dbid" {
    value = azurerm_resource_group.rgdb.id
}