resource "azurerm_resource_group" "this" {
  name     = "rg-${var.app}-${var.environment}-${var.region}"
  location = var.region
  tags     = var.tags
}