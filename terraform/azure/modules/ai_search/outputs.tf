output "id" {
  value = azurerm_search_service.this.id
}

output "name" {
  value = azurerm_search_service.this.name
}

output "endpoint" {
  value = azurerm_search_service.this.query_endpoint
}

output "primary_key" {
  # only if you still need it for some legacy app; otherwise you can drop this
  value       = azurerm_search_service.this.primary_key
  description = "Admin key of the Search service – protect in pipelines."
  sensitive   = true
}

output "identity_principal_id" {
  value       = try(azurerm_search_service.this.identity[0].principal_id, null)
  description = "Principal ID of the managed identity (if enabled)."
}

output "pe_id" {
  value = azurerm_private_endpoint.pe.id
}