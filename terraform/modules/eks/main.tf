data "aws_iam_role" "eks_cluster_role" {
  name = "${var.proj}-${var.environment}-${var.eks_cluster_role_arn_name}-iam-role"
}

data "aws_iam_role" "eks_node_role" {
  name = "${var.proj}-${var.environment}-${var.eks_node_group_role_arn_name}-iam-role"
}

resource "aws_eks_cluster" "this" {
  name     = "${var.proj}-${var.environment}-eks-cluster"
  role_arn = data.aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_ids
  }

  access_config {
    authentication_mode = "API"
  }
}

data "aws_ssm_parameter" "this" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.this.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.proj}-${var.environment}-nodegroup"
  version         = aws_eks_cluster.this.version
  release_version = nonsensitive(data.aws_ssm_parameter.this.value)
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    max_size     = var.max_size
    min_size     = var.min_size
    desired_size = var.desired_size
  }

  tags = {
    Name        = "${var.proj}-${var.environment}-${var.name}-eks"
    Environment = var.proj
  }
}

resource "aws_eks_access_entry" "this" {
  cluster_name      = aws_eks_cluster.this.name
  principal_arn     = "arn:aws:iam::160945804984:user/dorian"
  kubernetes_groups = ["eks-admin-group"]
  type              = "STANDARD"
  depends_on        = [aws_eks_cluster.this]
}

resource "aws_eks_access_policy_association" "this" {
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::160945804984:user/dorian"

  access_scope {
    type       = "namespace"
    namespaces = ["default"]
  }
  depends_on = [aws_eks_access_entry.this]
}