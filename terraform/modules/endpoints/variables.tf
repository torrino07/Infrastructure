variable "proj" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "rt_ids" {
  type = list(string)
}

variable "sg_ids" {
  type = list(string)
}

variable "vpc_endpoints" {
  type = list(string)
}

variable "vpc_endpoints_tags" {
  type = list(string)
}