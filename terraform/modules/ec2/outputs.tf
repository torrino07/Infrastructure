output "instance_private_ip" {
  description = "Private IP Address of the Development Trading Server"
  value       = aws_instance.this.private_ip
  sensitive   = true
}