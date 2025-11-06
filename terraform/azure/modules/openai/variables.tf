variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "custom_subdomain_name" { type = string }
variable "privatelink_subnet_id" { type = string }
variable "pdz_openai_id" { type = string }
variable "rbac_principals" {
  type    = list(object({ object_id = string, role = string }))
  default = []
}
variable "key_vault_key_id" { type = string }
variable "cmk_identity_client_id" { type = string }
variable "tags" { type = map(string) }