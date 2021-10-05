output "aiKey" {
  value = azurerm_application_insights.ai.instrumentation_key
}
output "aiConnectionString" {
  value = azurerm_application_insights.ai.connection_string
}