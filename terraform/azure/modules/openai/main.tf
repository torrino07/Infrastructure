resource "azurerm_cognitive_account" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
  custom_subdomain_name         = var.custom_subdomain_name
  tags                          = var.tags
}

# RBAC (prefer MI/AAD over API keys)
resource "azurerm_role_assignment" "rbac" {
  for_each             = { for p in var.rbac_principals : p.object_id => p }
  scope                = azurerm_cognitive_account.this.id
  role_definition_name = each.value.role # e.g., "Cognitive Services OpenAI User"
  principal_id         = each.value.object_id
}

# Optional CMK
resource "azurerm_cognitive_account_customer_managed_key" "cmk" {
  count                = var.key_vault_key_id == null ? 0 : 1
  cognitive_account_id = azurerm_cognitive_account.this.id
  key_vault_key_id     = var.key_vault_key_id
  identity_client_id   = var.cmk_identity_client_id
}

# Private Endpoint + DNS zone group
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
    private_dns_zone_ids = [var.pdz_openai_id] # privatelink.openai.azure.com
  }
}