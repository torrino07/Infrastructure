variable "proj" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "routes" {
  type = list(object({
    name                   = string
    type                   = string
    internet               = bool
    destination_cidr_block = optional(string)
    gateway_id             = optional(string)
    subnet_id              = string
  }))
}
