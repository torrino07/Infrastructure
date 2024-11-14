variable "proj" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(object({
    client_name_type = string
    route_type       = string
    az               = string
    number           = string
    cidr_block       = string
  }))
}
