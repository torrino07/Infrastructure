resource "aws_ec2_client_vpn_endpoint" "this" {
  client_cidr_block = var.client_cidr_block

  server_certificate_arn = "arn:aws:acm:us-east-1:160945804984:certificate/52ea92d7-217e-4b64-9df3-d2f4ba56455a"

  authentication_options {
    type = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:us-east-1:160945804984:certificate/52ea92d7-217e-4b64-9df3-d2f4ba56455a"
  }

  connection_log_options {
    enabled = false
    cloudwatch_log_group = "client-vpn-logs"
    cloudwatch_log_stream = "client-vpn-stream"
  }

  transport_protocol = "udp"
  dns_servers        = ["8.8.8.8"]

  split_tunnel = true

  tags = {
    Name = "${var.environment}-${var.name}-vpn"
  }
}

resource "aws_ec2_client_vpn_network_association" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = var.vpn_subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = var.vpc_cidr_block
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = var.ec2_subnet_cidr_block
  target_vpc_subnet_id   = var.vpn_subnet_id

  timeouts {
    create = "10m"
  }
}