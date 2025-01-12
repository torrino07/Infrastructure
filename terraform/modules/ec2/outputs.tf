output "trade_server_id" {
  value = aws_instance.this.id
}

output "trade_server_private_ip" {
  value = aws_instance.this.private_ip
}