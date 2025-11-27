resource "azurerm_cognitive_account" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "OpenAI"
  sku_name                      = "S0"
  custom_subdomain_name         = var.custom_subdomain_name
  public_network_access_enabled = false
  tags                          = var.tags

  # ► Assign UAMI(s) so CMK can be used
  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }
}

# RBAC for callers (apps/MI)
resource "azurerm_role_assignment" "rbac" {
  count = length(var.rbac_principals)

  scope                = azurerm_cognitive_account.this.id
  role_definition_name = var.rbac_principals[count.index].role
  principal_id         = var.rbac_principals[count.index].object_id
}

# ► Private Endpoint + zone group (unchanged)
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "aoai-psc"
    private_connection_resource_id = azurerm_cognitive_account.this.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "aoai-dns"
    private_dns_zone_ids = [var.pdz_openai_id]
  }
}