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

variable "s3_profile" {
  description = "The IAM instance profile for S3 access"
  type        = any
}