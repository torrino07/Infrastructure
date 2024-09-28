module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  environment = var.environment
}

module "subnet" {
  source              = "./modules/subnets"
  vpc_id              = module.vpc.vpc_id
  cidr_block          = "10.0.1.0/24"
  availability_zone   = "us-east-1a" 
  is_public           = false
  environment         = var.environment
  name                = "lambda"
}

module "security_group" {
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


# module "lambda" {
#   source              = "./modules/lambda"
#   vpc_id              = module.vpc.vpc_id
#   subnet_id           = module.subnet.subnet_id
#   cidr_block          = var.subnet_cidr_block
#   environment         = var.environment
#   depends_on = [module.subnet]
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
