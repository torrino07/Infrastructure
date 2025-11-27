variable "name" {
  description = "Storage account name (lowercase letters and digits only)."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "privatelink_subnet_id" {
  description = "Subnet ID used for Private Endpoint."
  type        = string
}

variable "pdz_blob_id" {
  description = "Private DNS zone ID for privatelink.blob.core.windows.net"
  type        = string
}

variable "containers" {
  description = "List of blob containers to create."
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "rbac_principals" {
  description = "Principals that get RBAC on the storage account."
  type = list(object({
    object_id = string
    role      = string
  }))
  default = []
}