# Create the EKS cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.environment}-${var.cluster_name}"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = [var.subnet_id]  # Inject more subnets for high availability
    security_group_ids = [var.sg_id]
  }
}

# EKS Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.environment}-${var.node_group_name}"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = [var.subnet_id]       # Inject more subnets for high availability

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  depends_on = [
    aws_eks_cluster.this
  ]
}