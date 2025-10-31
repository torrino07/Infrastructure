variable "org_id" { type = string }
variable "billing_account" { type = string }
variable "project_id" { type = string }

variable "app" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "tags" { type = map(string) }