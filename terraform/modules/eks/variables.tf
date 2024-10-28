variable "proj" {
  type = string
}

variable "eks_cluster_role_arn_name" {
  type = string
}

variable "eks_node_group_role_arn_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "desired_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "min_size" {
  type = string
}
