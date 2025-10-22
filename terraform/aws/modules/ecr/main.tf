resource "aws_ecr_repository" "this" {
  for_each = { for repo in var.repositories : repo.name => repo }

  name                 = each.value.name
  image_tag_mutability = each.value.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  force_delete = true

  tags = {
    Name    = "${var.proj}-${var.environment}-${each.value.name}-ecr"
    Project = var.proj
  }
}