resource "azurerm_storage_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true   # turn off later if going strict RBAC

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Modern API: use storage_account_id instead of name
resource "azurerm_storage_container" "containers" {
  for_each             = toset(var.containers)
  name                 = each.value
  storage_account_id   = azurerm_storage_account.this.id
  container_access_type = "private"
}

# RBAC for callers (e.g. ACA hub MI)
resource "azurerm_role_assignment" "rbac" {
  count = length(var.rbac_principals)

  scope                = azurerm_storage_account.this.id
  role_definition_name = var.rbac_principals[count.index].role
  principal_id         = var.rbac_principals[count.index].object_id
}

# Private endpoint for Blob
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-blob-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "blob-psc"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "blob-dns"
    private_dns_zone_ids = [var.pdz_blob_id]
  }
}