variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "disable_bgp_propagation" { type = bool }
variable "tags" { type = map(string) }
variable "routes" {
  type = list(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
    next_hop_ip    = optional(string)
  }))
  default = []
}
