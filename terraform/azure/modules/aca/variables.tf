variable "name" {
  description = "Base name for the Container App (also used for MI and env)."
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