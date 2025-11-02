resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = var.sku                      # e.g., "VpnGw2"
  active_active       = false
  enable_bgp          = true

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.this.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id        # must be "GatewaySubnet"
  }

  bgp_settings {
    asn = var.bgp_asn
  }

  tags = var.tags
}