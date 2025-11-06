variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "sku" { type = string }
variable "privatelink_subnet_id" { type = string }
variable "pdz_acr_id" { type = string }
variable "tags" { type = map(string) }