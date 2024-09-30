module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}


# module "amplify" {
#   source             = "./modules/amplify"
#   name               = "amplify"
#   region             = "us-east-1"
#   repository_url     = ""
#   github_token       = ""
#   domain_name        = "amplify"
#   branch_name        = var.environment
#   subdomain_prefix   = "www"
# }

# module "lambda_iam" {
#   source             = "./modules/iam"
#   policy_path        = "./metadata/LambdaAssumeRolePolicy.json"
#   role_name          = "lambda_exec_role"
#   policy_arn         = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# module "lambda" {
#   source             = "./modules/lambda"
#   name               = "lambda"
#   handler            = "index.handler"
#   runtime            = "python3.11"
#   iam_role           = module.lambda_iam.role_name
#   subnet_id          = module.lambda_subnet.subnet_id
#   security_group_id  = module.lambda_security_group.security_group_id
#   environment        = var.environment
# }

# module "routes" {
#   source                 = "./modules/routes"
#   vpc_id                 = module.vpc.vpc_id
#   subnet_id              = module.subnet.subnet_id
#   cidr_block             = var.cidr_block
#   environment            = var.environment
#   resource               = var.web_app_name
#   depends_on = [module.subnet]
# }

module "erc" {
  source       = "./modules/ecr"
  mutable      = "MUTABLE"
  name         = "fastapi-app"
  environment  = var.environment
}

module "erc_iam" {
  source             = "./modules/iam"
  policy_path        = "./metadata/ERCAssumeRolePolicy.json"
  role_name          = "erc_put_role"
  policy_arn         = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  environment        = var.environment
}