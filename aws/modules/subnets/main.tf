resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id  
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
  map_public_ip_on_launch = var.is_public

  tags = {
    Name = "${var.environment}-${var.name}-subnet"
    Environment = var.environment
  }
}