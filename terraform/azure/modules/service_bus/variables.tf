variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "privatelink_subnet_id" { type = string }
variable "queues" { type = list(string) }
variable "pdz_sb_id" { type = string }
variable "tags" { type = map(string) }
variable "sb_premium_partitions" { type = number }
