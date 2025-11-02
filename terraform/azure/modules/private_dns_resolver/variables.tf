variable "name"                { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "vnet_id"             { type = string }
variable "inbound_subnet_id"   { type = string }  # e.g., snet-dns-inbound
variable "outbound_subnet_id"  { type = string }  # e.g., snet-dns-outbound
variable "ruleset_vnet_ids"    { type = list(string)}

variable "forward_rules" {
  description = "Forward domains to target DNS (AWS/GCP/on-prem)."
  type = list(object({
    domain    = string   # e.g., "ec2.internal." or "corp.local."
    target_ip = string
  }))
  default = []
}
variable "tags" { type = map(string)}