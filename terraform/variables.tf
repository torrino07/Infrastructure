variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}