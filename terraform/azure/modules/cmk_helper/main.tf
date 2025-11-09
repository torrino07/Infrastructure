# UAMI used by the service (e.g., AOAI) for CMK operations
resource "azurerm_user_assigned_identity" "cmk" {
  name                = var.uami_name
  location            = var.region
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# RSA key (new version on change)
resource "azurerm_key_vault_key" "key" {
  name         = var.key_name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = var.key_size
  key_opts     = var.key_ops
}

# ---- Grant the UAMI rights to use the key ----
# Preferred: RBAC on the vault (assumes KV uses RBAC authorization)
resource "azurerm_role_assignment" "kv_crypto_user" {
  count                = var.use_access_policies ? 0 : 1
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.cmk.principal_id
}

# Alternative: legacy access policy (if your KV is set to Access Policies mode)
resource "azurerm_key_vault_access_policy" "policy" {
  count        = var.use_access_policies ? 1 : 0
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.cmk.principal_id

  key_permissions = [
    "Get", "WrapKey", "UnwrapKey", "Encrypt", "Decrypt", "Sign", "Verify",
  ]
}