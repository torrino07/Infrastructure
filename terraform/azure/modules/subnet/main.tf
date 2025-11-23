resource "azurerm_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = each.value.address_prefixes

  # Service endpoints (optional)
  service_endpoints = try(each.value.service_endpoints, [])

  # Delegation (optional)
  dynamic "delegation" {
    # Only create a delegation block if delegation is provided for this subnet
    for_each = try(each.value.delegation, null) == null ? [] : [each.value.delegation]

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service
        actions = try(delegation.value.actions, [])
      }
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