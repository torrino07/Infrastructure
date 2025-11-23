locals {
  zones_map = { for z in var.zones : z.name => z }
}

# Create zones
resource "azurerm_private_dns_zone" "zones" {
  for_each            = local.zones_map
  name                = each.value.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Link zones to VNets
resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = {
    for z in flatten([
      for z in var.zones : [
        for vnet in z.vnet_links : {
          key       = "${z.name}:${vnet.link_name}"
          zone_name = z.name
          link_name = vnet.link_name
          vnet_id   = vnet.vnet_id
          reg       = try(vnet.registration_enabled, false)
        }
      ]
    ]) : z.key => z
  }

  name                  = each.value.link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.value.zone_name].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = each.value.reg
  tags                  = var.tags
}

# Optional A records
resource "azurerm_private_dns_a_record" "records" {
  for_each = {
    for r in flatten([
      for z in var.zones : [
        for r in coalesce(try(z.a_records, []), []) : {
          key       = "${z.name}:${r.name}"
          zone_name = z.name
          name      = r.name
          ttl       = try(r.ttl, 300)
          records   = r.records
        }
      ]
    ]) : r.key => r
  }

  name                = each.value.name
  zone_name           = azurerm_private_dns_zone.zones[each.value.zone_name].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
}