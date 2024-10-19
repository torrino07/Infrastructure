resource "aws_eks_cluster" "this" {
  for_each   = toset(var.subnet_ids)
  name     = "${var.environment}-${var.cluster_name}"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = [each.value]
    security_group_ids = [var.sg_id]
  }
}

resource "aws_eks_node_group" "this" {
  for_each   = toset(var.subnet_ids)
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.environment}-${var.node_group_name}"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = [each.value]

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