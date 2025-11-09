variable "name" { type = string }
variable "region" { type = string }
variable "resource_group_name" { type = string }
variable "address_space" { type = list(string) }
variable "tags" { type = map(string) }
variable "dns_servers" {
  type    = list(string)
  default = []
}