variable "vpc_id" {
  description = "The ID of the VPC to which the subnet belongs"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
}

variable "is_public" {
  description = "Should instances launched in this subnet be assigned a public IP address?"
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment name (dev, prod, etc.)"
  type        = string
}

variable "name" {
  description = "The resource name"
  type        = string
}