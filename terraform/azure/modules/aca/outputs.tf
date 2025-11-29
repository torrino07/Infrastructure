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
  value       = var.identity_id
}

output "identity_principal_id" {
  description = "Principal ID of the user-assigned MI (for extra RBAC if needed)."
  value       = var.identity_principal_id
}

output "private_endpoint_id" {
  description = "ID of the private endpoint for the ACA environment (if created)."
  value       = try(azurerm_private_endpoint.aca_env[0].id, null)
}