resource "azurerm_cognitive_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Multi-service Cognitive Services
  kind     = "CognitiveServices"
  sku_name = var.sku_name

  custom_subdomain_name         = var.custom_subdomain_name
  public_network_access_enabled = false
  tags                          = var.tags

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 || var.identity_type == "SystemAssigned" ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }
}

resource "azurerm_role_assignment" "rbac" {
  count = length(var.rbac_principals)
  scope                = azurerm_cognitive_account.this.id
  role_definition_name = var.rbac_principals[count.index].role
  principal_id         = var.rbac_principals[count.index].object_id
}
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "cogsvc-psc"
    private_connection_resource_id = azurerm_cognitive_account.this.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name = "cogsvc-dns"

    # For Cognitive Services multi-service:
    # privatelink.cognitiveservices.azure.com
    private_dns_zone_ids = [var.pdz_cognitiveservices_id]
  }
}