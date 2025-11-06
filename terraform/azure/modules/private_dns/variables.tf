variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

# zones:
# - name: zone FQDN
# - vnet_links: list of { link_name, vnet_id, registration_enabled? }
# - a_records: (optional) list of { name, ttl?, records = [IPs] }
variable "zones" {
  type = list(object({
    name = string
    vnet_links = list(object({
      link_name            = string
      vnet_id              = string
      registration_enabled = optional(bool)
    }))
    a_records = optional(list(object({
      name    = string
      ttl     = optional(number)
      records = list(string)
    })))
  }))
}