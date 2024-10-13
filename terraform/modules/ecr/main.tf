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