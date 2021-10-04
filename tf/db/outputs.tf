output "dbHost" {
    value = "${azurerm_mysql_server.primaryServer.name}.mysql.database.azure.com"
}
output "dbName" {
    value = azurerm_mysql_database.mysqlDatabase.name
}
output "serverName" {
    value = azurerm_mysql_server.primaryServer.name
}
