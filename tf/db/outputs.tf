output "dbUser" {
    value = "${azurerm_mysql_server.mysqlServer.administrator_login}@${azurerm_mysql_server.mysqlServer.name}"
}
output "dbPass" {
    value = azurerm_mysql_server.mysqlServer.administrator_login_password
}
output "dbHost" {
    value = "${azurerm_mysql_server.mysqlServer.name}.mysql.database.azure.com"
}
output "dbName" {
    value = azurerm_mysql_database.mysqlDatabase.name
}