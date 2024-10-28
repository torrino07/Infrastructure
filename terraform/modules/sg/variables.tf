variable "vpc_id" {
  type = string
}

variable "proj" {
  type = string
}

variable "security_groups" {
  type = list(object({
    name = string
    ingress_rules = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])
    egress_rules = optional(list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])
  }))
  default = []
}
