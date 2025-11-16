variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "vnet_id" { type = string }
variable "inbound_subnet_id" { type = string }
variable "outbound_subnet_id" { type = string }
variable "forward_rules" {
  type = list(object({
    domain    = string
    target_ip = string
  }))
  default = []
}
variable "ruleset_vnet_ids" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}