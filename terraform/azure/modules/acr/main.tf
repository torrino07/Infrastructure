resource "azurerm_container_registry" "acr" {
  name                          = replace(var.name, "-", "")
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku # "Premium" recommended
  admin_enabled                 = false
  public_network_access_enabled = false
  tags                          = var.tags
}

resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "acr-psc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"] # add "data" if you need import
  }

  private_dns_zone_group {
    name                 = "acr-dns"
    private_dns_zone_ids = [var.pdz_acr_id] # privatelink.azurecr.io
  }

  tags = var.tags
}