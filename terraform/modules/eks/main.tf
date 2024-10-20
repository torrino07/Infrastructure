resource "aws_eks_cluster" "this" {
  name     = "${var.environment}-${var.cluster_name}"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.sg_id]
    
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

resource "kubernetes_config_map" "this" {
  depends_on = [aws_eks_cluster.this]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
    - rolearn: arn:aws:iam::160945804984:role/dev-eks-node-group-iam-role" 
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    YAML
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = "${var.environment}-${var.cluster_name}"
  node_group_name = "${var.environment}-${var.node_group_name}"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }
  instance_types = [var.instance_type]

  depends_on = [
    kubernetes_config_map.this
  ]
}