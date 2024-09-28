variable "vpc_id" {
  description = "The ID of the VPC to create the route table in"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "environment" {
  description = "The environment name (dev, prod, etc.)"
  type        = string
}