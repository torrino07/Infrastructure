variable "name" {
  description = "Base name for the Container App (also used for env)."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  description = "Subnet ID where the Container App Environment will be injected."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace for the ACA environment."
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID where the app MI will read secrets."
  type        = string
}

variable "image" {
  description = "Container image to run (e.g. ACR image)."
  type        = string
}

variable "container_name" {
  description = "Logical container name inside the Container App."
  type        = string
  default     = "api"
}

variable "target_port" {
  description = "Port exposed by the container."
  type        = number
}

variable "cpu" {
  description = "CPU cores for the container."
  type        = number
  default     = 0.5
}

variable "memory_gb" {
  description = "Memory for the container in GiB."
  type        = number
  default     = 1
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 3
}

variable "environment" {
  description = "Environment name (dev/stage/prod) for env vars."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "revision_mode" {
  description = "Revision mode for the Container App. Valid values: \"Single\" or \"Multiple\"."
  type        = string
  default     = "Single"
}

# ── Identity is provided by the caller (hub / spoke)
variable "identity_id" {
  description = "Resource ID of the user-assigned managed identity used by the app."
  type        = string
}

variable "identity_principal_id" {
  description = "Principal ID of the user-assigned managed identity (for RBAC)."
  type        = string
}

# ── Private Endpoint support for the ACA environment
variable "enable_private_endpoint" {
  description = "Whether to create a Private Endpoint for the Container App Environment."
  type        = bool
  default     = false
}

variable "privatelink_subnet_id" {
  description = "Subnet ID where the Private Endpoint NIC will live (usually snet-privatelink)."
  type        = string
  default     = null
}

variable "pdz_containerapps_id" {
  description = "Private DNS Zone ID for privatelink.<region>.azurecontainerapps.io."
  type        = string
  default     = null
}

# ── ACR / registry integration
variable "registry_server" {
  description = "Container registry server FQDN (e.g. hubeudevacr.azurecr.io)."
  type        = string
}

variable "registry_identity_id" {
  description = "Resource ID of the managed identity used to authenticate to the registry."
  type        = string
}