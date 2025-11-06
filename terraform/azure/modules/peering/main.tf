# modules/peering/main.tf
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = var.spoke_rg
  virtual_network_name      = var.spoke_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_virtual_network_access = true
  allow_gateway_transit        = var.allow_gateway_transit_spoke
  use_remote_gateways          = var.use_remote_gateways_spoke
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name       = var.hub_rg
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke_vnet_id

  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_virtual_network_access = true
  allow_gateway_transit        = var.allow_gateway_transit_hub
  use_remote_gateways          = var.use_remote_gateways_hub
}