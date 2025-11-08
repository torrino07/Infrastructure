output "uami_id" { value = azurerm_user_assigned_identity.cmk.id }
output "uami_client_id" { value = azurerm_user_assigned_identity.cmk.client_id }
output "uami_principal_id" { value = azurerm_user_assigned_identity.cmk.principal_id }

# Fully-qualified key id, includes version; when you rotate the key, this changes.
output "key_id" { value = azurerm_key_vault_key.key.id }