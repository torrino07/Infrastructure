locals {
  region = "us-east-1"
  ecr_modules = {
    "erc_react_app"         = { name = "fastapi-app", mutable = "MUTABLE"}
    "erc_fastapi_app"       = { name = "react-app", mutable = "MUTABLE" }
    "erc_postgresql_server" = { name = "postgresql-server", mutable = "MUTABLE" }
  }

  cognito = { name = "cognito" }

  certs = {
    server = { domain_name = "server" }
    client = { domain_name = "client1.domain.tld" }
  }

  vpn = {
    name                  = "turbo-x"
    vpc_cidr_block        = "10.1.0.0/16"
    client_cidr_block     = "172.16.0.0/22"
    ec2_subnet_cidr_block = "10.1.3.0/24"
    }

  vpc_cidr_block  = "10.1.0.0/16"
  
  subnets_modules = {
    "vpn_ni_subnet"  = { name = "vpn-network-interface", cidr_block = "10.1.1.0/24", availability_zone = "us-east-1a" }
    "ec2_subnet" = { name = "trading-server", cidr_block = "10.1.3.0/24", availability_zone = "us-east-1b" }
    "ks_subnet_a" = { name = "kubernetes_a", cidr_block = "10.1.2.0/24", availability_zone = "us-east-1b" }
    "ks_subnet_b" = { name = "kubernetes_b", cidr_block = "10.1.4.0/24", availability_zone = "us-east-1c" }
    "ecr_subnet" = { name = "ecr", cidr_block = "10.1.5.0/24", availability_zone = "us-east-1b" }
  }
  sg_modules = {
    "vpn_ni" = {
      ingress_rules = [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 1194
          to_port     = 1194
          protocol    = "udp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
      name = "vpn"
    }
    "ec2_sg" = {
      ingress_rules = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.1.1.0/24"]
        },
        {
          from_port   = 8000
          to_port     = 8000
          protocol    = "tcp"
          cidr_blocks = ["10.1.2.0/24", "10.1.4.0/24"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
      name = "trading-server"
    },
    "ks_sg" = {
      ingress_rules = [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.1.1.0/24", "10.1.5.0/24"]
        },
        {
          from_port   = 8000
          to_port     = 8000
          protocol    = "tcp"
          cidr_blocks = ["10.1.3.0/24"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
      name = "control"
    },
     "ecr_sg" = {
      ingress_rules = [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24", "10.1.4.0/24"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
      name = "registry"
    }
  }
  iam_modules = {
    ec2 = {
      assume_role_policy_path  = "./metadata/EC2AssumeRolePolicy.json",
      policy_arns              = [
         "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
         "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      ],
      name                     = "trading-server"
    },
    ks_clusters = {
      assume_role_policy_path  = "./metadata/EKSClusterAssumeRolePolicy.json",
      policy_arns              = [
         "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      ],
      name                     = "eks-cluster"
    },
    ks_node_group = {
      assume_role_policy_path = "./metadata/EKSNodeGroupAssumeRolePolicy.json",
      policy_arns              = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      ]
      name                     = "eks-node-group"
    }
  }

  ec2_modules = {
    "ec2_trading_server"      = { ami = "ami-053b0d53c279acc90", instance_type = "t2.micro"}  
  }

  ks_modules = { 
    ks_control = {
      cluster_name = "eks-cluster", 
      node_group_name  = "eks-node-group",  
      instance_type = "t3.medium",
      desired_capacity = 3,
      max_size = 5,
      min_size = 2
    }
  }
}

module "server_certs" {
  source        = "./modules/acm"
  domain_name   = local.certs.server.domain_name
}

module "client_certs"  {
  source        = "./modules/acm"
  domain_name   = local.certs.client.domain_name
}

module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = local.vpc_cidr_block
  environment = var.environment
}

module "subnets" {
  for_each          = local.subnets_modules
  source            = "./modules/subnets"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  name              = each.value.name
}

module "sg" {
  for_each      = local.sg_modules
  source        = "./modules/sg"
  environment   = var.environment
  vpc_id        = module.vpc.vpc_id
  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules
  name          = each.value.name
}

module "iam" {
  for_each                = local.iam_modules
  source                  = "./modules/iam"
  environment             = var.environment
  name                    = each.value.name
  assume_role_policy_path = each.value.assume_role_policy_path
  policy_arns             = each.value.policy_arns
}

# module "keys" {
#   source                  = "./modules/keys"
#   key_name                = "${var.environment}-key0010"
# }

# module "secret_manager" {
#   source                  = "./modules/secretmanager"
#   key_name                = module.keys.key_pair_name
#   private_key_pem         = module.keys.private_key_pem    
# }

# module "ec2" {
#   for_each               = local.ec2_modules
#   source                 = "./modules/ec2"
#   ami                    = each.value.ami
#   environment            = var.environment
#   private_subnet_id      = module.subnets["ec2_subnet"].subnet_id
#   iam_instance_profile   = module.arns["ec2"].iam_instance_profile_name
#   sg_private             = module.sg["ec2_sg"].security_group_id
#   instance_type          = each.value.instance_type
#   key_name               = module.keys.key_pair_name
# }

# module "kubernetes" {
#   for_each             = local.ks_modules
#   source               = "./modules/eks"
#   environment          = var.environment
#   subnet_ids           = [module.subnets["ks_subnet_a"].subnet_id, module.subnets["ks_subnet_b"].subnet_id]
#   sg_id                = module.sg["ks_sg"].security_group_id
#   eks_cluster_role_arn = module.arns["ks_clusters"].policy_arn
#   eks_node_role_arn    = module.arns["ks_node_group"].policy_arn
#   cluster_name         = each.value.cluster_name 
#   node_group_name      = each.value.node_group_name
#   desired_capacity     = each.value.desired_capacity
#   max_size             = each.value.max_size
#   min_size             = each.value.min_size
#   instance_type        = each.value.instance_type
# }

module "vpn" {
  source                = "./modules/vpn"
  vpc_cidr_block        = local.vpn.vpc_cidr_block
  client_cidr_block     = local.vpn.client_cidr_block
  ec2_subnet_cidr_block = local.vpn.ec2_subnet_cidr_block
  vpn_subnet_id         = module.subnets["vpn_ni_subnet"].subnet_id
  environment           = var.environment
  name                  = local.vpn.name
  server_arn            = module.server_certs.cert_arn
  client_arn            = module.client_certs.cert_arn
}

module "ecr" {
  for_each   = local.ecr_modules
  source     = "./modules/ecr"
  mutable    = each.value.mutable
  name       = each.value.name
  region     = local.region
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.subnets["ecr_subnet"].subnet_id
}

module "cognito" {
  source      = "./modules/cognito"
  name        = local.cognito.name
  environment = var.environment
}