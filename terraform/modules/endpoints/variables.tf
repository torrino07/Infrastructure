variable "vpc_id" {
  description = "The ID of the VPC to which the subnet belongs"
  type        = string
}

variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "name" {
  description = "The resource name"
  type        = string
}

variable "subnet_ids" {
  description = "The resource name"
  type        = string
}

variable "service_name" {
  description = "The resource name"
  type        = string
  default     = "com.amazonaws.us-east-1.ecr.dkr"
}

variable "subnet_ids" {
  description = "The resource name"
  type        = string
}

variable "vpc_endpoint_type" {
  description = "The resource name"
  type        = string
  default     = "Interface"
}