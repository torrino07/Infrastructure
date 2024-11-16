resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type

  tags = {
    Name    = "${var.proj}-${var.environment}-${name}"
    Project = "${var.proj}"
  }
}
