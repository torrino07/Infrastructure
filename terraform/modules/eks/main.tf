resource "aws_eks_cluster" "this" {
  name     = "${var.environment}-${var.cluster_name}"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.sg_id]
    
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = "${var.environment}-${var.cluster_name}"
  node_group_name = "${var.environment}-${var.node_group_name}"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids
  
  capacity_type = "ON_DEMAND"
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }
  depends_on = [aws_eks_cluster.this]
}