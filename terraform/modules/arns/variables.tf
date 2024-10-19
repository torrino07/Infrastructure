variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "name" {
  description = "Name"
  type        = string
}

variable "assume_role_policy_path" {
  description = "Path to the policy JSON files"
  type        = string
}

variable "policy_arns" {
  description = "Policy Arns"
  type        = list(string)
}