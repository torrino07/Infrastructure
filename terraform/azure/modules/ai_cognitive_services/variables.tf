variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  description = "Cognitive Services SKU, e.g. 'S0'."
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  type = string
}

variable "privatelink_subnet_id" {
  type = string
}

variable "pdz_cognitiveservices_id" {
  description = "Private DNS Zone ID for privatelink.cognitiveservices.azure.com"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "rbac_principals" {
  type    = list(object({ object_id = string, role = string }))
  default = []
}

variable "identity_type" {
  description = "Identity type: 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned', or 'None'."
  type        = string
  default     = "UserAssigned"
}

variable "identity_ids" {
  description = "List of UAMI IDs if using UserAssigned or combined identity."
  type        = list(string)
  default     = []
}