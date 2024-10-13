variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
}

variable "ingress_rules" {
  type = list(object({
    from_port  = number
    to_port    = number
    protocol   = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port  = number
    to_port    = number
    protocol   = string
    cidr_blocks = list(string)
  }))
  default = []
}