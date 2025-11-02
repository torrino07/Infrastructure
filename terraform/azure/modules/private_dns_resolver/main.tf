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
  ip_configurations {
    subnet_id = var.inbound_subnet_id
  }
  tags = var.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  name                    = "${var.name}-out"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = var.location
  subnet_id               = var.outbound_subnet_id
  tags                    = var.tags
}

resource "azurerm_private_dns_resolver_forwarding_rule" "rule" {
  for_each                  = { for r in var.forward_rules : r.domain => r }
  name                      = replace(each.value.domain, ".", "-")
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset[0].id
  domain_name               = each.value.domain
  enabled                   = true
  target_dns_servers {
    ip_address = each.value.target_ip
    port       = 53
  }
}

# Link ruleset to VNets that should use it (usually hub + spokes)
resource "azurerm_private_dns_resolver_virtual_network_link" "link" {
  for_each                  = { for id in var.ruleset_vnet_ids : id => id }
  name                      = "link-${replace(each.value, "/", "-")}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset[0].id
  virtual_network_id        = each.value
}