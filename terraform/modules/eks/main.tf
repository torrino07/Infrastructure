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

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.37.0-eksbuild.1"

  tags = {
    Name        = "${var.proj}-${var.environment}-${var.name}-ebs-csi-driver"
    Environment = var.proj
  }
  depends_on = [aws_eks_node_group.this]
}

resource "aws_eks_access_entry" "this" {
  for_each          = { for user in var.eks_users : user.name => user }
  cluster_name      = aws_eks_cluster.this.name
  principal_arn     = each.value.principal_arn
  kubernetes_groups = ["eks-admin"]
  type              = "STANDARD"

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_access_policy_association" "this" {
  for_each      = { for user in var.eks_users : user.name => user }
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn
  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.this]
}

data "aws_eks_cluster" "this" {
  name       = aws_eks_cluster.this.name
  depends_on = [aws_eks_access_policy_association.this]
}
resource "aws_iam_openid_connect_provider" "this" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960a6d40a546a6022c0ccaa57f4aa18"]

  tags = {
    Name = "${var.proj}-${var.environment}-${var.name}-oidc"
  }
  depends_on = [aws_eks_access_policy_association.this]
}

resource "aws_iam_role" "fastapi_role" {
  name = "FastAPIRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" : "system:serviceaccount:dev:fastapi-sa"
          }
        }
      }
    ]
  })
  depends_on = [aws_iam_openid_connect_provider.this]
}

resource "aws_iam_role_policy_attachment" "ec2_read_only" {
  role       = aws_iam_role.fastapi_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  depends_on = [aws_iam_role.fastapi_role]
}

resource "aws_iam_role_policy_attachment" "ssm_full_access" {
  role       = aws_iam_role.fastapi_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  depends_on = [aws_iam_role.fastapi_role]
}

resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.account_id}:oidc-provider/${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:aud" : "sts.amazonaws.com",
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
  depends_on = [aws_iam_openid_connect_provider.this]
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  depends_on = [aws_iam_role.ebs_csi_driver_role]
}
