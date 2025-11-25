variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "custom_subdomain_name" { type = string }
variable "privatelink_subnet_id" { type = string }
variable "pdz_openai_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}

# RBAC (keep)
variable "rbac_principals" {
  type    = list(object({ object_id = string, role = string }))
  default = []
}

# ► NEW: AOAI account will run with a User-Assigned MI (required for CMK)
variable "identity_ids" {
  description = "List of UAMI resource IDs to assign to the Cognitive Account (required for CMK)."
  type        = list(string)
  default     = []
}