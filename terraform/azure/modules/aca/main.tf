########### Managed Identity for the app ###########
resource "azurerm_user_assigned_identity" "app" {
  name                = "${var.name}-mi"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

########### Container Apps Environment (VNet, private) ###########
resource "azurerm_container_app_environment" "env" {
  name                = "${var.name}-env"
  resource_group_name = var.resource_group_name
  location            = var.location

  # VNet integration → private only
  infrastructure_subnet_id        = var.subnet_id
  internal_load_balancer_enabled  = true

  # Logging – simplest: require a workspace id from caller
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = var.tags
}

########### Role on Key Vault for the app MI ###########
resource "azurerm_role_assignment" "kv_secrets" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

########### Container App (internal only, with MI) ###########
resource "azurerm_container_app" "app" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  container_app_environment_id = azurerm_container_app_environment.env.id

  # NEW: required by provider
  revision_mode = var.revision_mode  # e.g. "Single"

  tags = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  ingress {
    external_enabled = false
    target_port      = var.target_port
    transport        = "auto"

    # NEW: required by provider – route 100% traffic to latest revision
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