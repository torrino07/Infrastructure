variable "proj" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "gateway_id" {
  type = string
}

variable "tags" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}