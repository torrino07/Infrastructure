module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}

module "ec2_subnet" {
  source            = "./modules/subnets"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  name              = "trading-server"
}

module "ec2_sg" {
  source              = "./modules/sg"
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id

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
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["10.0.2.0/24"]
    }
  ]
  name                    = "trading-server"
}

module "ec2_iam_profile" {
  source                  = "./modules/iam"
  assume_role_policy_path = "./metadata/EC2AssumeRoloPolicy.json"
  policy_path             = "./metadata/EC2Policy.json"
  name                    = "ec2"
  environment             = var.environment
}

module "ec2" {
  source                 = "./modules/ec2"
  ami                    = "ami-053b0d53c279acc90"
  environment            = var.environment
  private_subnet_id      = module.ec2_subnet.subnet_id
  s3_profile             = module.ec2_iam_profile.ss_profile_name
  sg_private             = module.ec2_sg.security_group_id
  instance_type          = "t2.micro"
}

locals {
  ecr_modules = {
    "erc_react_app"      = { name = "fastapi-app" }
    "erc_fastapi_app"    = { name = "react-app" }
    "erc_postgresql_server" = { name = "postgresql_server" }
  }
}

module "ecr_modules" {
  for_each = local.ecr_modules
  source   = "./modules/ecr"
  mutable  = "MUTABLE"
  name     = each.value.name
}

module "cognito" {
  source     = "./modules/cognito"
  name       = "cognito"
  environment = var.environment
}