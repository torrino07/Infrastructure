resource "aws_ec2_client_vpn_endpoint" "this" {
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.cidr_block

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.ca_certificate_body
  }

  connection_log_options {
    enabled = false
  }

  split_tunnel = false

  tags = {
    Environment = "${var.environment}"
    Name        = "${var.proj}-${var.environment}-vpn-client"
  }
}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.subnet_id
}
