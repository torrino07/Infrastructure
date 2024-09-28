# output "private_key_dev" {
#   value     = module.key_pair.private_key_dev
#   description = "The generated RSA private key dev."
#   sensitive = true
# }

# output "private_key_test" {
#   value     = module.key_pair.private_key_test
#   description = "The generated RSA private key test."
#   sensitive = true
# }

# output "private_key_prod" {
#   value     = module.key_pair.private_key_prod
#   description = "The generated RSA private key prod."
#   sensitive = true
# }

# output "dev_instance_public_ip" {
#   description = "Public IP of the development trading server"
#   value       = module.ec2_instance.dev_instance_public_ip
#   sensitive = true
# }

# output "test_instance_public_ip" {
#   description = "Public IP of the test trading server"
#   value       = module.ec2_instance.test_instance_public_ip
#   sensitive = true
# }

# output "prod_instance_public_ip" {
#   description = "Public IP of the production trading server"
#   value       = module.ec2_instance.prod_instance_public_ip
#   sensitive = true
# }
