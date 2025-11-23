resource "azurerm_private_dns_resolver" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.vnet_id
  tags                = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  name                    = "${var.name}-in"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.location
  ip_configurations { subnet_id = var.inbound_subnet_id }
  tags = var.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  name                    = "${var.name}-out"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.location
  subnet_id               = var.outbound_subnet_id
  tags                    = var.tags
}

# Only create ruleset if there are forward rules
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset" {
  name                                       = "${var.name}-ruleset"
  resource_group_name                        = var.resource_group_name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound.id]
  tags                                       = var.tags
}
# N rules only if ruleset exists
resource "azurerm_private_dns_resolver_forwarding_rule" "rule" {
  count                     = length(var.forward_rules) > 0 ? length(var.forward_rules) : 0
  name                      = replace(var.forward_rules[count.index].domain, ".", "-")
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.id
  domain_name               = var.forward_rules[count.index].domain
  enabled                   = true
  target_dns_servers {
    ip_address = var.forward_rules[count.index].target_ip
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "link" {
  count                     = length(var.forward_rules) > 0 ? length(var.ruleset_vnet_ids) : 0
  name                      = "link-${count.index}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.id
  virtual_network_id        = var.ruleset_vnet_ids[count.index]
}