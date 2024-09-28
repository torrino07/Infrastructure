variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
}

variable "web_app_name" {
  description = "The name for the web app"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}