output "url" {
    value = "${azurerm_app_service.web.name}.azurewebsites.net"
}
output "whiteList" {
    value = azurerm_app_service.web.outbound_ip_addresses
}