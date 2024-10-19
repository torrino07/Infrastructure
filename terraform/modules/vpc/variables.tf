variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}