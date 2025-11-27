output "id" {
  value = azurerm_storage_account.this.id
}

output "name" {
  value = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "container_names" {
  value = [for c in azurerm_storage_container.containers : c.name]
}

output "pe_id" {
  value = azurerm_private_endpoint.pe.id
}

output "identity_principal_id" {
  value       = azurerm_storage_account.this.identity[0].principal_id
  description = "System-assigned identity of the Storage Account."
}