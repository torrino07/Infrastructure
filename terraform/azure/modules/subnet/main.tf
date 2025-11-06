resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = each.value.address_prefixes

  # service endpoints (optional if you also do Private Endpoints)
  service_endpoints = try(each.value.service_endpoints, [])
  delegation {
    name = try(each.value.delegation.name, null)
    service_delegation {
      name    = try(each.value.delegation.service, null)
      actions = try(each.value.delegation.actions, [])
    }
  }
}

# NSG association (optional)
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = { for s in var.subnets : s.name => s if try(s.nsg_id, null) != null }
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id
}

# UDR association (optional)
resource "azurerm_subnet_route_table_association" "rt_assoc" {
  for_each       = { for s in var.subnets : s.name => s if try(s.route_table_id, null) != null }
  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}