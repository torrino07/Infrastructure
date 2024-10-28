################# VPC #################
module "vpc" {
  source               = "./modules/vpc"
  proj                 = var.proj
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

############### SUBNETS ###############
module "subnets" {
  source                  = "./modules/subnets"
  proj                    = var.proj
  vpc_id                  = module.vpc.id
  az                      = var.az
  subnets                 = var.subnets
  tags                    = var.tags
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

################ ROUTES ###############
module "routes" {
  source      = "./modules/routes"
  proj        = var.proj
  vpc_id      = module.vpc.id
  cidr_block  = var.cidr_block
  gateway_id  = var.gateway_id
  subnet_ids  = module.subnets.ids
  tags        = var.tags
}

########## SECURITY GROUPS ###########
module "sg" {
  source          = "./modules/sg"
  proj            = var.proj
  vpc_id          = module.vpc.id
  security_groups = [
    {
      name = "endpoint"
      ingress_rules = [
        { 
          from_port   = 443, 
          to_port     = 443, 
          protocol    = "tcp", 
          cidr_blocks = [var.cidr_block] 
        }
      ]
      egress_rules = []
    }
  ]
}

############# ENDPOINTS #############
data "aws_subnets" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.proj}-subnet-eks-1a", "${var.proj}-subnet-eks-1b"]
  }
}

data "aws_security_groups" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.proj}-sg-endpoint"]
  }
}

data "aws_route_tables" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.proj}-rt-eks-1a", "${var.proj}-rt-eks-1b"]
  }
}

module "endpoints" {
  source             = "./modules/endpoints"
  proj               = var.proj
  vpc_id             = module.vpc.id
  vpc_endpoints      = var.vpc_endpoints
  vpc_endpoints_tags = var.vpc_endpoints_tags
  subnet_ids         = data.aws_subnets.this.ids
  sg_ids             = data.aws_security_groups.this.ids
  rt_ids             = data.aws_route_tables.this.ids
}

############## IAM ##############
module "iam" {
  source = "./modules/iam"
  proj   = var.proj
  roles = [
    {
      name        = "AmazonEKSClusterRole"
      effect      = "Allow"
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
      actions     = ["sts:AssumeRole"]
      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      ]
    },
    {
      name        = "AmazonEKSNodeRole"
      effect      = "Allow"
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
      actions     = ["sts:AssumeRole"]
      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      ]
    },
     {
      name        = "AmazonEC2Role"
      effect      = "Allow"
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
      actions     = ["sts:AssumeRole"]
      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      ]
    }
  ]
}

############ EKS ############
module "eks" {
  depends_on                   = [module.iam, data.aws_subnets.this]
  source                       = "./modules/eks"
  proj                         = var.proj
  eks_cluster_role_arn_name    = "AmazonEKSClusterRole"
  eks_node_group_role_arn_name = "AmazonEKSNodeRole"
  eks_version                  = var.eks_version
  subnet_ids                   = module.subnets.ids
  max_size                     = var.max_size
  min_size                     = var.min_size
  desired_size                 = var.desired_size
}
