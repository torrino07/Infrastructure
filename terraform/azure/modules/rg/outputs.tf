output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "The name of the resource group."
}

output "resource_group_id" {
  value       = azurerm_resource_group.this.id
  description = "The ARM ID of the resource group."
}

output "resource_group_location" {
  value       = azurerm_resource_group.this.location
  description = "The location/region of the resource group."
}

output "resource_group_tags" {
  value       = azurerm_resource_group.this.tags
  description = "Tags applied to the resource group."
}

output "resource_group_name_computed" {
  value       = "rg-${var.app}-${var.environment}-${var.region}"
  description = "Computed RG name from variables."
}

output "resource_group" {
  value = {
    id       = azurerm_resource_group.this.id
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
    tags     = azurerm_resource_group.this.tags
  }
  description = "Selected properties of the resource group."
}