variable "proj" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_endpoints" {
  type = list(object({
    service_name        = string
    vpc_endpoint_type   = string
    security_group_ids  = optional(list(string))
    subnet_ids          = optional(list(string))
    route_table_ids     = optional(list(string))
    private_dns_enabled = optional(bool, true)
    tag                 = string
  }))
}
