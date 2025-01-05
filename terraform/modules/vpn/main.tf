resource "aws_ec2_client_vpn_endpoint" "this" {
  server_certificate_arn = var.server_arn
  client_cidr_block      = var.client_cidr_block
  vpc_id                 = var.vpc_id
  vpn_port               = 443
  dns_servers            = ["8.8.8.8"]
  session_timeout_hours  = 8
  transport_protocol     = "udp"
  security_group_ids     = [var.sg_id]
  self_service_portal    = "enabled"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_arn
  }

  connection_log_options {
    enabled               = false
    cloudwatch_log_group  = "client-vpn-logs"
    cloudwatch_log_stream = "client-vpn-stream"
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
  target_network_cidr    = var.target_network_cidr
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "this" {
  for_each               = var.destination_cidr_blocks
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = each.value
  target_vpc_subnet_id   = var.subnet_id

  timeouts {
    create = "10m"
  }
}
