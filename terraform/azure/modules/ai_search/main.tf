resource "azurerm_search_service" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  partition_count = var.partition_count
  replica_count   = var.replica_count

  public_network_access_enabled = false
  local_authentication_enabled  = false

  tags = var.tags

  dynamic "identity" {
    for_each = var.identity_type == "None" ? [] : [1]
    content {
      type         = var.identity_type   # e.g. "SystemAssigned" or "UserAssigned"
      identity_ids = var.identity_ids
    }
  }
}

# RBAC for callers (apps/MI) – e.g. ACA MI, agent MI, admin group
resource "azurerm_role_assignment" "rbac" {
  for_each             = { for p in var.rbac_principals : p.object_id => p }
  scope                = azurerm_search_service.this.id
  role_definition_name = each.value.role
  principal_id         = each.value.object_id
}

# Private Endpoint for Azure AI Search
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "search-psc"
    private_connection_resource_id = azurerm_search_service.this.id
    is_manual_connection           = false
    # For Azure AI Search this subresource is 'searchService'
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "search-dns"
    # privatelink.search.windows.net
    private_dns_zone_ids = [var.pdz_search_id]
  }
}