output "vaultName" {
    value = azurerm_key_vault.vault.name
}
output "vaultRG" {
    value = azurerm_key_vault.vault.resource_group_name
}
output "principalId" {
    value = azurerm_user_assigned_identity.id.principal_id
}
output "tenantId" {
    value = azurerm_user_assigned_identity.id.tenant_id
}
output "vaultId" {
    value = azurerm_key_vault.vault.id
}
output "identityId" {
    value = azurerm_user_assigned_identity.id.id
}
output "secretUriUser" {
    value = azurerm_key_vault_secret.username.id
}
output "secretUriPass" {
    value = azurerm_key_vault_secret.password.id
}