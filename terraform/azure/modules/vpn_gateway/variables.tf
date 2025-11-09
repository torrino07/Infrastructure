variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "region" { type = string }
variable "gateway_subnet_id" { type = string }
variable "sku" { type = string }
variable "bgp_asn" { type = number }
variable "tags" { type = map(string) }