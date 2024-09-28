module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}

module "lambda_subnet" {
  source              = "./modules/subnets"
  vpc_id              = module.vpc.vpc_id
  cidr_block          = "10.0.1.0/24"
  availability_zone   = "us-east-1a" 
  is_public           = false
  environment         = var.environment
  name                = "lambda"
}

module "lambda_security_group" {
  source             = "./modules/sg"
  vpc_id             = module.vpc.vpc_id
  ingress_from_port  = 443
  ingress_to_port    = 443
  ingress_protocol   = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_from_port   = 0
  egress_to_port     = 0
  egress_protocol    = "-1"
  egress_cidr_blocks = ["0.0.0.0/0"]
  name               = "lambda"
  environment        = var.environment
}

module "lambda_iam" {
  source             = "./modules/iam"
  policy_path        = "./metadata/LambdaAssumeRolePolicy.json"
  role_name          = "lambda_exec_role"
  policy_arn         = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "lambda" {
  source             = "./modules/lambda"
  name               = "lambda"
  handler            = "index.handler"
  runtime            = "python3.11"
  iam_role           = module.lambda_iam.role_name
  subnet_id          = module.lambda_subnet.subnet_id
  security_group_id  = module.lambda_security_group.security_group_id
  environment        = var.environment
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
