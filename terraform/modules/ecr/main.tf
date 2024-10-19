resource "aws_ecr_repository" "this" {
  name                 = "${var.name}"
  image_tag_mutability = var.mutable
  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids  = [var.sg_private_id]
  subnet_ids          = [var.subnet_id]

  tags = {
    "Name" = "${var.environment}-ecr-dkr"
  }
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  security_group_ids  = [var.sg_private_id]
  subnet_ids          = [var.subnet_id]

  tags = {
    "Name" = "${var.environment}-ecr-api"
  }
}