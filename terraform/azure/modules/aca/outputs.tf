output "environment_id" {
  value = azurerm_container_app_environment.env.id
}

output "app_name" {
  value = azurerm_container_app.app.name
}

output "app_id" {
  value = azurerm_container_app.app.id
}

output "app_fqdn" {
  # internal FQDN used inside the VNet
  value = azurerm_container_app.app.ingress[0].fqdn
}

output "identity_id" {
  description = "Resource ID of the user-assigned MI used by the app."
  value       = azurerm_user_assigned_identity.app.id
}

output "identity_principal_id" {
  description = "Principal ID of the user-assigned MI (for extra RBAC if needed)."
  value       = azurerm_user_assigned_identity.app.principal_id
}