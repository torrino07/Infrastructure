variable "name" { type = string }
variable "region" { type = string }
variable "resource_group_name" { type = string }
variable "retention_days" { type = number }
variable "tags" { type = map(string) }