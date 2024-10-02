module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}

# module "routes" {
#   source                 = "./modules/routes"
#   vpc_id                 = module.vpc.vpc_id
#   subnet_id              = module.subnet.subnet_id
#   cidr_block             = var.cidr_block
#   environment            = var.environment
#   resource               = var.web_app_name
#   depends_on = [module.subnet]
# }

module "erc_fastapi" {
  source       = "./modules/ecr"
  mutable      = "MUTABLE"
  name         = "fastapi-app"
  environment  = var.environment
}

module "erc_react" {
  source       = "./modules/ecr"
  mutable      = "MUTABLE"
  name         = "react-app"
  environment  = var.environment
}

module "erc_iam" {
  source             = "./modules/iam"
  policy_path        = "./metadata/ERCAssumeRolePolicy.json"
  role_name          = "erc_put_role"
  policy_arn         = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  environment        = var.environment
}

module "cognito" {
  source     = "./modules/cognito"
  name       = "cognito"
  environment = var.environment
}