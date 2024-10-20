variable "vpc_id" {
  description = "The ID of the VPC to create the route table in"
  type        = string
}
variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "subnet_ids" {
  description = "The ID of the subnet"
  type        = list(string)
}