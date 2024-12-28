################# VPC #################
module "vpc" {
  source               = "./modules/vpc"
  proj                 = var.proj
  environment          = var.environment
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

############### SUBNETS ###############
module "subnets" {
  source      = "./modules/subnets"
  proj        = var.proj
  environment = var.environment
  region      = var.region
  vpc_id      = module.vpc.id
  subnets = [
    {
      client_name_type = "eks"
      route_type       = "private"
      az               = "1a"
      number           = "1"
      cidr_block       = "10.0.128.0/23"
    },
    {
      client_name_type = "eks"
      route_type       = "private"
      az               = "1b"
      number           = "1"
      cidr_block       = "10.0.144.0/23"
    },
    {
      client_name_type = "ec2"
      route_type       = "private"
      az               = "1c"
      number           = "1"
      cidr_block       = "10.0.160.0/23"
    },
    {
      client_name_type = "nat"
      route_type       = "public"
      az               = "1c"
      number           = "1"
      cidr_block       = "10.0.0.0/24"
    },
  ]
}

######### SECURITY GROUPS ###########
module "sg" {
  source      = "./modules/sg"
  proj        = var.proj
  environment = var.environment
  vpc_id      = module.vpc.id
  security_groups = [
    {
      name = "ebs-endpoint"
      ingress_rules = [
        {
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["10.0.0.0/16"]
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
      name = "ec2-ecr-eks-endpoint"
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
          cidr_blocks = ["10.0.128.0/23", "10.0.144.0/23", "10.0.160.0/23"]
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
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["10.0.128.0/23", "10.0.144.0/23"]
        },
        {
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["10.0.0.0/24"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443,
          to_port     = 443,
          protocol    = "tcp",
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    },

    {
      name = "eks"
      ingress_rules = [
        {
          from_port   = 8000,
          to_port     = 8000,
          protocol    = "tcp",
          cidr_blocks = ["10.0.160.0/23"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0,
          to_port     = 0,
          protocol    = "-1",
          cidr_blocks = ["10.0.160.0/23"]
        }
      ]
    },
    {
      name = "sts-endpoint"
      ingress_rules = [
        {
          from_port   = 443,
          to_port     = 443,
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

############ GATEAWAY ###########
module "gw" {
  source      = "./modules/gw"
  proj        = var.proj
  vpc_id      = module.vpc.id
  environment = var.environment
  subnet_id   = module.subnets.ids["tradingbot-${var.environment}-nat-public-1c-1"]
}

############## ROUTES ###############
module "routes" {
  source = "./modules/routes"
  proj   = var.proj
  vpc_id = module.vpc.id
  routes = [
    {
      name      = "tradingbot-${var.environment}-eks-private-1a-1"
      type      = "private"
      internet  = false
      subnet_id = module.subnets.ids["tradingbot-${var.environment}-eks-private-1a-1"]
    },
    {
      name      = "tradingbot-${var.environment}-eks-private-1b-1"
      type      = "private"
      internet  = false
      subnet_id = module.subnets.ids["tradingbot-${var.environment}-eks-private-1b-1"]
    },
    {
      name                   = "tradingbot-${var.environment}-ec2-private-1c-1"
      type                   = "private"
      internet               = true
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = module.gw.nat_gateway_id
      subnet_id              = module.subnets.ids["tradingbot-${var.environment}-ec2-private-1c-1"]
    },
    {
      name                   = "tradingbot-${var.environment}-nat-public-1c-1"
      type                   = "public"
      internet               = true
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = module.gw.internet_gateway_id
      subnet_id              = module.subnets.ids["tradingbot-${var.environment}-nat-public-1c-1"]
    }
  ]
}

########## ENDPOINTS #############
module "endpoints" {
  source      = "./modules/endpoints"
  proj        = var.proj
  environment = var.environment
  vpc_id      = module.vpc.id
  vpc_endpoints = [
    {
      service_name       = "com.amazonaws.${var.region}.ebs"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ebs-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
      tag                = "ebs"
    },

    {
      service_name       = "com.amazonaws.${var.region}.ec2"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
      tag                = "ec2"
    },
    {
      service_name       = "com.amazonaws.${var.region}.ecr.api"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
      tag                = "ecr-api"
    },
    {
      service_name       = "com.amazonaws.${var.region}.ecr.dkr"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
      tag                = "ecr-dkr"
    },
    {
      service_name       = "com.amazonaws.${var.region}.eks"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
      tag                = "eks"
    },
    {
      service_name      = "com.amazonaws.${var.region}.s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = [for tag, id in module.routes.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1-rt", "tradingbot-${var.environment}-eks-private-1b-1-rt", "tradingbot-${var.environment}-ec2-private-1c-1-rt"], tag)]
      tag               = "s3"
    },
    {
      service_name       = "com.amazonaws.${var.region}.ec2messages"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ssm-https-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1", "tradingbot-${var.environment}-ec2-private-1c-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ec2messages"
    },
    {
      service_name       = "com.amazonaws.${var.region}.ssm"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ssm-https-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1", "tradingbot-${var.environment}-ec2-private-1c-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ssm"
    },

    {
      service_name       = "com.amazonaws.${var.region}.ssmmessages"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-ssm-https-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1", "tradingbot-${var.environment}-ec2-private-1c-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ssmmessages"
    },
    {
      service_name       = "com.amazonaws.${var.region}.sts"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-${var.environment}-sts-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "sts"
    }
  ]
}

############## IAM ##############
module "iam" {
  source      = "./modules/iam"
  proj        = var.proj
  environment = var.environment
  roles = [
    {
      name        = "AmazonEKSClusterRole"
      effect      = "Allow"
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
      actions     = ["sts:AssumeRole"]
      policy_arns = [
        "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      ],
      access_level = "readonly"
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
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      ],
      access_level = "readwrite"
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
      ],
      access_level = "readwrite"
    }
  ]
}

module "s3" {
  depends_on  = [module.endpoints]
  source      = "./modules/s3"
  proj        = var.proj
  environment = var.environment
  bucket      = "${var.artifact_store}-${var.environment}"
  policy = {
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Principal = "*"
        Resource = [
          "arn:aws:s3:::${var.artifact_store}-${var.environment}",
          "arn:aws:s3:::${var.artifact_store}-${var.environment}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = module.endpoints.ids["tradingbot-${var.environment}-s3"]
          }
        }
      }
    ]
  }
}

############ EC2 ############
module "ec2" {
  depends_on    = [module.iam]
  source        = "./modules/ec2"
  proj          = var.proj
  environment   = var.environment
  name          = "trading-server"
  subnet_id     = module.subnets.ids["tradingbot-${var.environment}-ec2-private-1c-1"]
  sg_id         = module.sg.ids["tradingbot-${var.environment}-ec2-sg"]
  instance_type = var.ec2_instance_type
  ami           = var.ec2_ami_type
  role_arn_name = "AmazonEC2Role"
  access_level  = "readwrite"
}

########### EBS ############
module "ebs" {
  depends_on        = [module.iam]
  source            = "./modules/ebs"
  proj              = var.proj
  environment       = var.environment
  ebs_volume_size   = 20
  ebs_volume_type   = "gp3"
  availability_zone = "${var.region}a"
}

########### EKS ############
module "eks" {
  depends_on                   = [module.iam]
  source                       = "./modules/eks"
  proj                         = var.proj
  environment                  = var.environment
  account_id                   = var.account_id
  name                         = "node"
  eks_cluster_role_arn_name    = "AmazonEKSClusterRole"
  eks_node_group_role_arn_name = "AmazonEKSNodeRole"
  eks_version                  = var.eks_version
  subnet_ids                   = [for tag, id in module.subnets.ids : id if contains(["tradingbot-${var.environment}-eks-private-1a-1", "tradingbot-${var.environment}-eks-private-1b-1"], tag)]
  security_ids                 = [for tag, id in module.sg.ids : id if tag == "eks"]
  max_size                     = 3
  min_size                     = 1
  desired_size                 = 3
  eks_users = [
    {
      name          = "dorian"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::${var.account_id}:user/dorian"
    },
    {
      name          = "cicd-pipeline"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::${var.account_id}:user/cicd-pipeline"
    }
  ]
}

###### COGNITO ##########
module "cognito" {
  source      = "./modules/cognito"
  proj        = var.proj
  environment = var.environment
  name        = "x-turbo"
}

######### ECR ##########
module "ecr" {
  source      = "./modules/ecr"
  proj        = var.proj
  environment = var.environment
  repositories = [
    {
      name                 = "fastapi-app"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "react-app"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    }
    ,
    {
      name                 = "postgresql-server"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "metrics-scraper"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "dashboard"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "controller"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "kube-webhook-certgen"
      scan_on_push         = true
      image_tag_mutability = "MUTABLE"
    }
  ]
}

