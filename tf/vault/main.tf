provider "azurerm" {
  version = "=2.78.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "vault" {
  name                            = "${var.resourcePrefix}-vault"
  location                        = var.location
  resource_group_name             = var.rgName
  enabled_for_disk_encryption     = false
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  soft_delete_enabled             = false

  sku_name                        = "standard"
}

resource "azurerm_user_assigned_identity" "id" {
  name                            = "${var.resourcePrefix}-id"
  location                        = var.location
  resource_group_name             = var.rgName
}

resource "azurerm_key_vault_access_policy" "default" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "Set", "Delete", "List"
  ]

  key_permissions = [
    "Get", "Create", "Delete", "List"
  ]

  storage_permissions = [
    "Get", "GetSAS", "Delete", "DeleteSAS", "Set", "RegenerateKey"
  ]

  certificate_permissions = [
    "Create", "Get", "Delete" ,"List"
  ]
}

resource "azurerm_key_vault_access_policy" "id" {
  key_vault_id = azurerm_key_vault_access_policy.default.key_vault_id
  tenant_id    = azurerm_user_assigned_identity.id.tenant_id
  object_id    = azurerm_user_assigned_identity.id.principal_id

  secret_permissions = [
    "Get", "List"
  ]
}

#####################
## Vault Secret ##
#####################

resource "azurerm_key_vault_secret" "username" {
  name         = "${var.resourcePrefix}-mysql-user"
  value        = "${var.adminName}@${var.serverName}"
  key_vault_id = azurerm_key_vault_access_policy.default.key_vault_id
}

resource "azurerm_key_vault_secret" "password" {
  name         = "${var.resourcePrefix}-mysql-pass"
  value        = var.adminPass
  key_vault_id = azurerm_key_vault_access_policy.default.key_vault_id
}