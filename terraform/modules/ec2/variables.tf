variable "proj" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "sg_id" {
  type = any
}

variable "access_level" {
  type = any
}
variable "role_arn_name" {
  type = string
}

