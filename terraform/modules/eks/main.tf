module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "${var.environment}-${var.cluster_name}"
  cluster_version = "1.31"

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true
  


  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids
  enable_irsa              = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = [var.instance_type]
    vpc_security_group_ids = [var.sg_id]
  }

  eks_managed_node_groups = {
    node_group = {
      capacity_type        = "ON_DEMAND"
      name                 = "${var.environment}-general"
      desired_size         = var.desired_capacity
      max_size             = var.max_size
      min_size             = var.min_size
    }

  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "${var.environment}"
    name        = "${var.environment}-eks"
  }
}
