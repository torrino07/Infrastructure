resource "aws_ec2_client_vpn_endpoint" "this" {
  server_certificate_arn = var.server.arn
  client_cidr_block      = var.cidr_block
  vpc_id                 = var.vpc_id
  vpn_port               = 443
  session_timeout_hours  = 8
  transport_protocol     = "udp"
  security_group_ids     = [var.sg_id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client.arn
  }

  connection_log_options {
    enabled = false
  }

  split_tunnel = true

  tags = {
    Environment = "${var.environment}"
    Name        = "${var.proj}-${var.environment}-vpn"
  }
}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.subnet_id
  depends_on             = [aws_ec2_client_vpn_endpoint.this]
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr = var.target_network_cidr
  authorize_all_groups = true
}