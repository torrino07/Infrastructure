resource "azurerm_resource_group" "this" {
  name     = "rg-${var.app}-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}