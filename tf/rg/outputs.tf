output "rgdb" {
    value = azurerm_resource_group.rgdb.name
}
output "rgstorage" {
    value = azurerm_resource_group.rgstorage.name
}
output "rgwaf" {
    value = azurerm_resource_group.rgwaf.name
}
output "primary_rgweb" {
    value = azurerm_resource_group.primary_rgweb.name
}
output "secondary_rgweb" {
    value = azurerm_resource_group.secondary_rgweb.name
}
output "primary_rgvault" {
    value = azurerm_resource_group.primary_rgvault.name
}
output "secondary_rgvault" {
    value = azurerm_resource_group.secondary_rgvault.name
}
