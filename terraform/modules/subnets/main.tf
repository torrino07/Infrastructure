resource "aws_subnet" "this" {
  count             = length(var.az)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnets[count.index]
  availability_zone = var.az[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch[count.index]

  tags = {
    Name = "${var.proj}-subnet-${var.tags[count.index]}"
  }
}