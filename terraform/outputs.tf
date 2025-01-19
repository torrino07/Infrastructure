output "user_pool_id" {
  value = module.cognito.user_pool_id
}

output "client_id" {
  value = module.cognito.client_id
}

output "bastion_host_id" {
  value = module.ec2.id
}

output "trade_server_id" {
  value = module.ec2.id
}

output "trade_server_private_ip" {
  value = module.ec2.private_ip
}