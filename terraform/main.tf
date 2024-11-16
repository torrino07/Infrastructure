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
          from_port   = 8000,
          to_port     = 8000,
          protocol    = "tcp",
          cidr_blocks = ["10.0.160.0/23"]
        }
      ]
    }
  ]
}

############## ROUTES ###############
module "routes" {
  source     = "./modules/routes"
  proj       = var.proj
  vpc_id     = module.vpc.id
  cidr_block = "10.0.0.0/16"
  gateway_id = "local"
  subnet_ids = module.subnets.ids
}

########### ENDPOINTS #############
module "endpoints" {
  source      = "./modules/endpoints"
  proj        = var.proj
  environment = var.environment
  vpc_id      = module.vpc.id
  vpc_endpoints = [
    {
      service_name       = "com.amazonaws.us-east-1.ebs"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ebs-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1"], tag)]
      tag                = "ebs"
    },

    {
      service_name       = "com.amazonaws.us-east-1.ec2"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if  tag == "tradingbot-dev-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1"], tag)]
      tag                = "ec2"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ecr.api"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1"], tag)]
      tag                = "ecr-api"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ecr.dkr"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1"], tag)]
      tag                = "ecr-dkr"
    },
    {
      service_name       = "com.amazonaws.us-east-1.eks"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ec2-ecr-eks-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1"], tag)]
      tag                = "eks"
    },
    {
      service_name      = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = [for tag, id in module.routes.ids : id if contains(["tradingbot-dev-eks-private-1a-1-rt", "tradingbot-dev-eks-private-1b-1-rt", "tradingbot-dev-ec2-private-1c-1-rt"], tag)]
      tag               = "s3"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ec2messages"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ssm-https-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1", "tradingbot-dev-ec2-private-1c-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ec2messages"
    },
    {
      service_name       = "com.amazonaws.us-east-1.ssm"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ssm-https-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1", "tradingbot-dev-ec2-private-1c-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ssm"
    },

    {
      service_name       = "com.amazonaws.us-east-1.ssmmessages"
      vpc_endpoint_type  = "Interface"
      security_group_ids = [for tag, id in module.sg.ids : id if tag == "tradingbot-dev-ssm-https-endpoint-sg"]
      subnet_ids         = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1", "tradingbot-dev-ec2-private-1c-1"], tag)]
      ip_address_type    = "ipv4"
      tag                = "ssmmessages"
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
        "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
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
  bucket      = "artifactstore001"
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
          "arn:aws:s3:::artifactstore001",
          "arn:aws:s3:::artifactstore001/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = module.endpoints.ids["tradingbot-dev-s3"]
          }
        }
      }
    ]
  }
}

############# EC2 ############
module "ec2" {
  depends_on    = [module.iam]
  source        = "./modules/ec2"
  proj          = var.proj
  environment   = var.environment
  name          = "trading-server"
  subnet_id     = module.subnets.ids["tradingbot-dev-ec2-private-1c-1"]
  sg_id         = module.sg.ids["tradingbot-dev-ec2-sg"]
  instance_type = "t4g.medium"
  ami           = "ami-07ee04759daf109de"
  role_arn_name = "AmazonEC2Role"
  access_level  = "readwrite"
}

############# EBS ############
module "ebs" {
  depends_on        = [module.iam]
  source            = "./modules/ebs"
  proj              = var.proj
  environment       = var.environment
  name              = "eks-ebs"
  ebs_volume_size   = 20
  ebs_volume_type   = "gp3"
  availability_zone = "us-east-1a"
}

############ EKS ############
module "eks" {
  depends_on                   = [module.iam]
  source                       = "./modules/eks"
  proj                         = var.proj
  environment                  = var.environment
  eks_cluster_role_arn_name    = "AmazonEKSClusterRole"
  eks_node_group_role_arn_name = "AmazonEKSNodeRole"
  eks_version                  = "1.31.1"
  subnet_ids                   = [for tag, id in module.subnets.ids : id if contains(["tradingbot-dev-eks-private-1a-1", "tradingbot-dev-eks-private-1b-1"], tag)]
  security_ids                 = [for tag, id in module.sg.ids : id if tag == "eks"]
  max_size                     = 1
  min_size                     = 1
  desired_size                 = 1
}

######## COGNITO ##########
module "cognito" {
  source      = "./modules/cognito"
  proj        = var.proj
  environment = var.environment
  name        = "x-turbo"
}

########## ECR ##########
module "ecr" {
  source      = "./modules/ecr"
  proj        = var.proj
  environment = var.environment
  repositories = [
    {
      name                 = "fastapi-app"
      scan_on_push         = true
      image_tag_mutability = "IMMUTABLE"
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
    }
  ]
}

