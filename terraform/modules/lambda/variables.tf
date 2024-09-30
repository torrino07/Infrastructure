variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}


variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}


variable "security_group_id" {
  description = "SG Id"
  type        = string
}

variable "runtime" {
  description = "Runtime"
  type        = string
}
variable "name" {
  description = "Name of the lambda function"
  type        = string
}

variable "handler" {
  description = "Handler name"
  type        = string
}

variable "iam_role" {
  description = "IAM role"
  type        = string
}