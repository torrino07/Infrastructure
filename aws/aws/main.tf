module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.cidr_block
  environment = var.environment
}

module "subnet" {
  source              = "./modules/subnets"
  vpc_id              = module.vpc.vpc_id
  cidr_block          = var.subnet_cidr_block
  availability_zone   = var.availability_zone
  map_public_ip_on_launch = false
  environment         = var.environment
  resource            = var.web_app_name
}

module "eb" {
  source              = "./modules/eb"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.subnet.subnet_id
  cidr_block          = var.subnet_cidr_block
  environment         = var.environment
  depends_on = [module.subnet]
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



# module "subnets" {
#   source = "./modules/subnets"
#   vpc_id = module.vpc.vpc_id
# }

# module "internet_gateway" {
#   source = "./modules/internet_gateway"
#   vpc_id = module.vpc.vpc_id
#   depends_on = [module.vpc]
# }

# module "routes" {
#   source                 = "./modules/routes"
#   vpc_id                 = module.vpc.vpc_id
#   dev_public_subnet_id   = module.subnets.dev_public_subnet_id
#   test_public_subnet_id  = module.subnets.test_public_subnet_id
#   prod_public_subnet_id  = module.subnets.prod_public_subnet_id
#   internet_gateway_id    = module.internet_gateway.internet_gateway_id
#   depends_on = [module.subnets, module.internet_gateway]
# }

# module "security_groups" {
#   source = "./modules/security_groups"
#   vpc_id = module.vpc.vpc_id
#   depends_on = [module.vpc]
# }

# module "database" {
#   source = "./modules/rds"
#   dev_private_subnet_1_id = module.subnets.dev_private_subnet_1_id
#   dev_private_subnet_2_id = module.subnets.dev_private_subnet_2_id
#   test_private_subnet_1_id = module.subnets.test_private_subnet_1_id
#   test_private_subnet_2_id = module.subnets.test_private_subnet_2_id
#   prod_private_subnet_1_id = module.subnets.prod_private_subnet_1_id
#   prod_private_subnet_2_id = module.subnets.prod_private_subnet_2_id
#   sg_private_id            = module.security_groups.sg_private_id
#   depends_on = [module.subnets, module.security_groups]
# }

# module "key_pair" {
#   source = "./modules/keys"
# }

# module "iam_configuration" {
#   source = "./modules/iam"
# }

# module "ec2_instance" {
#   source               = "./modules/ec2"

#   key_name_dev         = module.key_pair.key_pair_name_dev
#   key_name_test        = module.key_pair.key_pair_name_test
#   key_name_prod        = module.key_pair.key_pair_name_prod

#   private_key_pem_dev  = module.key_pair.private_key_dev
#   private_key_pem_test = module.key_pair.private_key_test
#   private_key_pem_prod = module.key_pair.private_key_prod

#   dev_public_subnet    = module.subnets.dev_public_subnet_id
#   test_public_subnet   = module.subnets.test_public_subnet_id
#   prod_public_subnet   = module.subnets.prod_public_subnet_id

#   db_endpoint_dev      = module.database.dev_postgresql_endpoint
#   db_endpoint_test     = module.database.test_postgresql_endpoint
#   db_endpoint_prod     = module.database.prod_postgresql_endpoint

#   username_dev         = module.database.db_username_dev
#   password_dev         = module.database.db_password_dev

#   username_test        = module.database.db_username_test
#   password_test        = module.database.db_password_test
  
#   username_prod        = module.database.db_username_prod
#   password_prod        = module.database.db_password_prod

#   sg_public            = module.security_groups.sg_public_id
#   sg_private           = module.security_groups.sg_private_id
#   s3_profile           = module.iam_configuration.s3_profile
#   depends_on = [module.key_pair, module.subnets, module.security_groups, module.iam_configuration, module.database]
# }
