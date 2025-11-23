output "id" { value = azurerm_private_dns_resolver.this.id }
output "inbound_ip" { value = azurerm_private_dns_resolver_inbound_endpoint.inbound.ip_configurations[0].private_ip_address }
output "outbound_id" { value = azurerm_private_dns_resolver_outbound_endpoint.outbound.id }
output "ruleset_id" {
  value = length(var.forward_rules) > 0 ? azurerm_private_dns_resolver_dns_forwarding_ruleset.id : null
}