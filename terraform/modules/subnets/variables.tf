variable "proj" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "az" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "tags" {
  type = list(string)
}

variable "map_public_ip_on_launch" {
  type = list(bool)
}