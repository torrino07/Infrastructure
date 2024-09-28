variable "vpc_id" {
  description = "The ID of the VPC to which the subnet belongs"
  type        = string
}


variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}


variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}
