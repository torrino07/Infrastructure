variable "vpc_id" {
  description = "The ID of the VPC to create the route table in"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "resource" {
  description = "The resource name"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}