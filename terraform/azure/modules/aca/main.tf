########### Container Apps Environment (VNet, private) ###########
resource "azurerm_container_app_environment" "env" {
  name                = "${var.name}-env"
  resource_group_name = var.resource_group_name
  location            = var.location

  # VNet integration → private only
  infrastructure_subnet_id       = var.subnet_id
  internal_load_balancer_enabled = true

  # Logging
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = var.tags
}

########### Role on Key Vault for the app MI ###########
resource "azurerm_role_assignment" "kv_secrets" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.identity_principal_id
}

########### Container App (internal only, with MI) ###########
resource "azurerm_container_app" "app" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  container_app_environment_id = azurerm_container_app_environment.env.id
  revision_mode                = var.revision_mode

  tags = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  ingress {
    external_enabled = false
    target_port      = var.target_port
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    container {
      name   = var.container_name
      image  = var.image
      cpu    = var.cpu
      memory = "${var.memory_gb}Gi"

      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = var.environment
      }
    }
  }
}

########### Private Endpoint for ACA Environment (optional) ###########
resource "azurerm_private_endpoint" "aca_env" {
  count               = var.enable_private_endpoint ? 1 : 0

  name                = "${var.name}-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.privatelink_subnet_id

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_container_app_environment.env.id
    subresource_names              = ["managedEnvironment"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "aca-env-dns"
    private_dns_zone_ids = [var.pdz_containerapps_id]
  }

  tags = var.tags
}