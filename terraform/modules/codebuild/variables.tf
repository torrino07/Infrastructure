variable "proj" {
  type = string
}

variable "environment" {
  type = string
}

variable "role_arn_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "sg_ids" {
  type = list(string)
}