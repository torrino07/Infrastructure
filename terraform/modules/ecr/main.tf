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

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids   = [var.subnet_id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.ecr.dkr"
  subnet_ids   = [var.subnet_id]
}