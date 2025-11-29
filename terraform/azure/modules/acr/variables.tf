variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "sku" {
  type    = string
  default = "Premium"
}
variable "privatelink_subnet_id" {
  type = string
}
variable "pdz_acr_id" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "rbac_principals" {
  description = "Principals to give roles on the ACR"
  type = list(object({
    object_id = string
    role      = string
  }))
  default = []
}