resource "azurerm_key_vault" "kv" {
  name                          = var.name
  location                      = var.region
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  public_network_access_enabled = false
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "pe" {
  name                = "${var.name}-pe"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "kv-psc"
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "kv-dns"
    private_dns_zone_ids = [var.pdz_vaultcore_id] # privatelink.vaultcore.azure.net
  }

  tags = var.tags
}