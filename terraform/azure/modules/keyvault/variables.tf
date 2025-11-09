variable "name" { type = string }
variable "region" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tenant_id" { type = string }
variable "privatelink_subnet_id" { type = string }
variable "pdz_vaultcore_id" { type = string }
variable "tags" { type = map(string) }