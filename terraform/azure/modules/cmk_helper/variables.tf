variable "uami_name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "key_vault_id" { type = string } # existing KV (hub)
variable "key_name" {
  type    = string
  default = "aoai-cmk-key"
}
variable "key_size" {
  type    = number
  default = 3072
}
variable "key_ops" {
  type    = list(string)
  default = ["wrapKey", "unwrapKey", "encrypt", "decrypt", "sign", "verify"]
}

# If your KV is using legacy Access Policies instead of RBAC, flip this to true and pass tenant_id.
variable "use_access_policies" {
  type    = bool
  default = false
}
variable "tenant_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}