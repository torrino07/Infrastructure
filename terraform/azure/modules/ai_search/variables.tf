variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  description = "Search SKU, e.g. 'standard', 'standard3', 'basic'. Check allowed values per region."
  type        = string
  default     = "standard"
}

variable "partition_count" {
  type    = number
  default = 1
}

variable "replica_count" {
  type    = number
  default = 1
}

variable "privatelink_subnet_id" {
  type = string
}

variable "pdz_search_id" {
  description = "Private DNS Zone ID for privatelink.search.windows.net"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# RBAC
variable "rbac_principals" {
  description = "Principals that get roles on the Search service"
  type        = list(object({ object_id = string, role = string }))
  default     = []
}

# Managed Identity
variable "identity_type" {
  description = "Identity type for Search: 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned', or 'None'."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "List of UAMI IDs if using UserAssigned or combo identity."
  type        = list(string)
  default     = []
}