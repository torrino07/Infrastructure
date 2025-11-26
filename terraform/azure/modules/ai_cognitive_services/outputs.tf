output "id" {
  value = azurerm_cognitive_account.this.id
}

output "endpoint" {
  value = azurerm_cognitive_account.this.endpoint
}

output "pe_id" {
  value = azurerm_private_endpoint.pe.id
}

output "identity_principal_id" {
  value       = try(azurerm_cognitive_account.this.identity[0].principal_id, null)
  description = "Principal ID of the cognitive account MI, if enabled."
}