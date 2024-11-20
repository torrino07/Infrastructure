variable "proj" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "eks_users" {
  description = "List of users to provide EKS access"
  type = list(object({
    name          = string
    policy_arn    = string
    principal_arn = string
  }))
  default = [
    {
      name          = "dorian"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::160945804984:user/dorian"
    },
    {
      name          = "cicd-pipeline"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::160945804984:user/cicd-pipeline"
    }
  ]
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

variable "security_ids" {
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
