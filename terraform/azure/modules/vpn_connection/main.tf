resource "azurerm_local_network_gateway" "peer" {
  name                = "${var.name}-lngw"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.peer_public_ip
  bgp_settings { 
    asn = var.peer_bgp_asn  
    bgp_peering_address = var.peer_bgp_peering_address
    }
  tags = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "conn" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  type                       = "IPsec"
  virtual_network_gateway_id = var.vpn_gateway_id
  local_network_gateway_id   = azurerm_local_network_gateway.peer.id
  shared_key                 = var.ipsec_psk
  enable_bgp                 = true
  tags = var.tags
}