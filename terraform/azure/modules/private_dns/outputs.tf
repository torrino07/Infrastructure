# modules/private_dns/outputs.tf
output "zone_ids" { value = { for k, z in azurerm_private_dns_zone.zones : k => z.id } }
output "zone_names" { value = keys(azurerm_private_dns_zone.zones) }