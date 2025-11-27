output "id" {
  value = azurerm_cognitive_account.this.id
}

output "name" {
  value = azurerm_cognitive_account.this.name
}

output "endpoint" {
  value = "https://${azurerm_cognitive_account.this.name}.cognitiveservices.azure.com"
}

output "pe_id" {
  value = azurerm_private_endpoint.pe.id
}