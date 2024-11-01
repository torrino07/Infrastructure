variable "proj" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnets" {
  type = list(object({
    tag                     = string
    az                      = string
    cidr_block              = string
    map_public_ip_on_launch = bool
  }))
}
