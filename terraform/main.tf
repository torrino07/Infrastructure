locals {
  ecr_modules = {
    "erc_react_app"         = { name = "fastapi-app" }
    "erc_fastapi_app"       = { name = "react-app" }
    "erc_postgresql_server" = { name = "postgresql_server" }
  }
  subnets_modules = {
    "ec2_subnet" = { name = "trading-server", cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a" }
    "ni_subnet"  = { name = "vpn-network-interface", cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a" }
  }
  sg_modules = {
    "ec2_sg" = {
      ingress_rules = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.8.0.0/16"]
        },
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["10.0.2.0/24"]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["10.0.2.0/24"]
        }
      ]
      name = "trading-server"
    }
  }
  iam_profiles_modules = {
    ec2_iam_profiles = {
      assume_role_policy_path = "./metadata/EC2AssumeRolePolicy.json",
      policy_path             = "./metadata/EC2Policy.json",
      name                    = "ec2"
    }
  }
  ec2_modules = {
    "ec2_trading_server"      = { ami = "ami-053b0d53c279acc90", instance_type = "t2.micro"}  
  }
  
}

module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = "10.0.0.0/16"
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

module "iam_profiles" {
  for_each                = local.iam_profiles_modules
  source                  = "./modules/iam"
  assume_role_policy_path = each.value.assume_role_policy_path
  policy_path             = each.value.policy_path
  name                    = each.value.name
  environment             = var.environment
}

module "ec2" {
  for_each          = local.ec2_modules
  source            = "./modules/ec2"
  ami               = each.value.ami
  environment       = var.environment
  private_subnet_id = module.subnets["ec2_subnet"].subnet_id
  s3_profile        = module.iam_profiles["ec2_iam_profiles"].ss_profile_name
  sg_private        = module.sg["ec2_sg"].security_group_id
  instance_type     = each.value.instance_type
}

module "ecr" {
  for_each = local.ecr_modules
  source   = "./modules/ecr"
  mutable  = "MUTABLE"
  name     = each.value.name
}

module "cognito" {
  source      = "./modules/cognito"
  name        = "cognito"
  environment = var.environment
}
