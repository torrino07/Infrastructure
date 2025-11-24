resource "azurerm_servicebus_namespace" "ns" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Premium"
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
  tags                          = var.tags
  capacity                      = var.capacity
}

resource "azurerm_servicebus_queue" "queues" {
  for_each     = toset(var.queues)
  name         = each.key
  namespace_id = azurerm_servicebus_namespace.ns.id
}

resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "sb-psc"
    private_connection_resource_id = azurerm_servicebus_namespace.ns.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  private_dns_zone_group {
    name                 = "sb-dns"
    private_dns_zone_ids = [var.pdz_sb_id] # privatelink.servicebus.windows.net
  }

  tags = var.tags
}