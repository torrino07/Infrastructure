variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "ingress_from_port" {
  description = "Ingress from port"
  type        = number
}

variable "ingress_to_port" {
  description = "Ingress to port"
  type        = number
}

variable "ingress_protocol" {
  description = "Ingress protocol (e.g., tcp)"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks for ingress rules"
  type        = list(string)
}

variable "egress_from_port" {
  description = "Egress from port"
  type        = number
}

variable "egress_to_port" {
  description = "Egress to port"
  type        = number
}

variable "egress_protocol" {
  description = "Egress protocol (e.g., tcp)"
  type        = string
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks for egress rules"
  type        = list(string)
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
}