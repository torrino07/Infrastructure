variable "mutable" {
  description = "Mutable tag"
  type        = string
}

variable "name"{
    description = "Name of the Registry"
    type        = string
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ids"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to which the subnet belongs"
  type        = string
}

variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}


variable "sg_private_id" {
  description = "The private security group for the EC2 instance"
  type        = any
}
