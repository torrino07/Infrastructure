variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "cluster_name" {
  description = "Name"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = string
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = string
}

variable "min_size" {
  description = "Maximum number of worker nodes"
  type        = string
}

variable "instance_type" {
  description = "Maximum number of worker nodes"
  type        = string
}

variable "eks_cluster_role_arn" {
  description = "Name of Arn"
  type        = string
}

variable "sg_id" {
  description = "sg id"
  type        = string
}

variable "eks_node_role_arn" {
  description = "eks node role arn"
  type        = string
}

variable "node_group_name" {
  description = "node group name"
  type        = string
}

variable "subnet_ids" {
  description = "The ID of the subnet"
  type        = list(string)
}