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

variable "subnet_ids" {
  type = map(string)
}
