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
  source = "./modules/subnets"
  proj   = var.proj
  vpc_id = module.vpc.id
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
    {
      tag                     = "ec2-1b"
      az                      = "us-east-1b"
      cidr_block              = "10.0.160.0/23"
      map_public_ip_on_launch = false
    },
  ]
}

######### SECURITY GROUPS ###########
module "sg" {
  source = "./modules/sg"
  proj   = var.proj
  vpc_id = module.vpc.id
  security_groups = [
    {
      name = "eks-endpoint"
      ingress_rules = [
        {
          from_port   = 443,
          to_port     = 443,
          protocol    = "tcp",
          cidr_blocks = ["10.0.0.0/16"]
        }
      ]
      egress_rules = []
    },
    {
      name = "ssm-https-endpoint"
      ingress_rules = [
        {
          from_port   = 443,
          to_port     = 443,
          protocol    = "tcp",
          cidr_blocks = ["10.0.160.0/23"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },
    {
      name = "ec2"
      ingress_rules = [
        {
          from_port   = 443,
          to_port     = 443,
          protocol    = "tcp",
          cidr_blocks = ["10.0.160.0/23"]
        },
        {
          from_port   = 8000,
          to_port     = 8000,
          protocol    = "tcp",
          cidr_blocks = ["10.0.128.0/23", "10.0.144.0/23"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  ]
}

############### ROUTES ###############
module "routes" {
  source     = "./modules/routes"
  proj       = var.proj
  vpc_id     = module.vpc.id
  cidr_block = "10.0.0.0/16"
  gateway_id = "local"
  subnet_ids = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
  tags       = ["eks-1a", "eks-1b"]
}

########### ENDPOINTS #############
module "endpoints" {
  source = "./modules/endpoints"
  proj   = var.proj
  vpc_id = module.vpc.id
  vpc_endpoints = [
    {
      service_name       = "com.amazonaws.us-east-1.ec2"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-eks-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
      tag                = "ec2"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ecr.api"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-eks-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
      tag                = "ecr-api"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ecr.dkr"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-eks-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
      tag                = "ecr-dkr"
    },
    {
      service_name       = "com.amazonaws.us-east-1.eks"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-eks-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
      tag                = "eks"
    },
    {
      service_name      = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = [for tag, id in module.routes.ids : id if contains(["dev-rt-eks-1a", "dev-rt-eks-1b"], tag)]
      tag               = "s3"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ec2messages"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-ssm-https-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-ec2-1b"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ec2messages"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ssm"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-ssm-https-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-ec2-1b"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ssm"
    },

    {
      service_name       = "com.amazonaws.us-east-1.ssmmessages"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if contains(["dev-sg-ssm-https-endpoint"], tag)]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-ec2-1b"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ssmmessages"
    },

  ]
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

############# EC2 ############
module "ec2" {
  depends_on    = [module.iam]
  source        = "./modules/ec2"
  proj          = var.proj
  subnet_id     = module.subnets.ids["dev-subnet-ec2-1b"]
  sg_id         = module.sg.ids["dev-sg-ec2"]
  instance_type = "t4g.medium"
  ami           = "ami-07ee04759daf109de"
  role_arn_name = "AmazonEC2Role"
  tag           = "trading-server"
}

# ############ EKS ############
# module "eks" {
#   depends_on                   = [module.iam]
#   source                       = "./modules/eks"
#   proj                         = var.proj
#   eks_cluster_role_arn_name    = "AmazonEKSClusterRole"
#   eks_node_group_role_arn_name = "AmazonEKSNodeRole"
#   eks_version                  = "1.28"
#   subnet_ids                   = [for tag, id in module.subnets.ids : id if contains(["dev-subnet-eks-1a", "dev-subnet-eks-1b"], tag)]
#   max_size                     = 1
#   min_size                     = 1
#   desired_size                 = 1
# }
