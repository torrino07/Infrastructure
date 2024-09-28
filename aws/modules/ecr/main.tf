resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.mutable
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.environment}-${var.name}"
  }
}