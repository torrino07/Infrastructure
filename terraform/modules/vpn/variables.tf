variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "name" {
  description = "The resource name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "client_cidr_block" {
  description = "The client CIDR block for the VPC"
  type        = string
}

variable "ec2_subnet_cidr_block" {
  description = "The client CIDR block for the VPC"
  type        = string
}

variable "vpn_subnet_id" {
  description = "VPN subnet ID"
  type        = string
}