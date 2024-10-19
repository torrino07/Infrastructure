variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "ami" {
  description = "ID of the first private subnet"
  type        = string
}

variable "instance_type" {
  description = "ID of the first private subnet"
  type        = string
}
variable "private_subnet_id" {
  description = "ID of the first private subnet"
  type        = string
}
variable "sg_private" {
  description = "The private security group for the EC2 instance"
  type        = any
}

variable "iam_instance_profile" {
  description = "The IAM instance profile"
  type        = any
}

variable "key_name" {
  description = "Name for the AWS key pair in the development environment"
  type        = string
}