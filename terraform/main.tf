################# VPC #################
module "vpc" {
  source               = "./modules/vpc"
  proj                 = var.proj
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

############### SUBNETS ###############
module "subnets" {
  source      = "./modules/subnets"
  proj        = var.proj
  vpc_id      = module.vpc.id
  subnets = [
    {
      tag                     = "eks-1a"
      az                      = "us-east-1a"
      cidr_block              = "10.0.128.0/23",
      map_public_ip_on_launch = false
    },
    {
      tag                     = "eks-1b"
      az                      = "us-east-1b"
      cidr_block              = "10.0.144.0/23",
      map_public_ip_on_launch = false
    },
  ]
}

######### SECURITY GROUPS ###########
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
          cidr_blocks = ["10.0.0.0/16"] 
        }
      ]
      egress_rules = []
    }
  ]
}

############### ROUTES ###############
module "routes" {
  source      = "./modules/routes"
  proj        = var.proj
  vpc_id      = module.vpc.id
  cidr_block  = "10.0.0.0/16"
  gateway_id  = "local"
  subnet_ids  = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
  tags        = ["eks-1a", "eks-1b"]
}

# ############# ENDPOINTS #############
# module "endpoints" {
#   source             = "./modules/endpoints"
#   proj               = var.proj
#   vpc_id             = module.vpc.id
#   vpc_endpoints      = var.vpc_endpoints
#   vpc_endpoints_tags = var.vpc_endpoints_tags
#   subnet_ids         = data.aws_subnets.this.ids
#   sg_ids             = data.aws_security_groups.this.ids
#   rt_ids             = data.aws_route_tables.this.ids
# }

# ############## IAM ##############
# module "iam" {
#   source = "./modules/iam"
#   proj   = var.proj
#   roles = [
#     {
#       name        = "AmazonEKSClusterRole"
#       effect      = "Allow"
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com"]
#       actions     = ["sts:AssumeRole"]
#       policy_arns = [
#         "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#       ]
#     },
#     {
#       name        = "AmazonEKSNodeRole"
#       effect      = "Allow"
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#       actions     = ["sts:AssumeRole"]
#       policy_arns = [
#         "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#         "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#         "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#       ]
#     },
#      {
#       name        = "AmazonEC2Role"
#       effect      = "Allow"
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#       actions     = ["sts:AssumeRole"]
#       policy_arns = [
#         "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
#         "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
#       ]
#     }
#   ]
# }

# ############ EKS ############
# module "eks" {
#   depends_on                   = [module.iam, data.aws_subnets.this]
#   source                       = "./modules/eks"
#   proj                         = var.proj
#   eks_cluster_role_arn_name    = "AmazonEKSClusterRole"
#   eks_node_group_role_arn_name = "AmazonEKSNodeRole"
#   eks_version                  = var.eks_version
#   subnet_ids                   = module.subnets.ids
#   max_size                     = var.max_size
#   min_size                     = var.min_size
#   desired_size                 = var.desired_size
# }
