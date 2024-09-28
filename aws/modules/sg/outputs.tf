output "elastic_beanstalk_private_sg" {
  description = "The ID of the public security group"
  value       = aws_security_group.elastic_beanstalk_private_sg
}
