data "aws_iam_instance_profile" "this" {
  name = "${var.proj}-instance-profile-${var.role_arn_name}"
}
resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile   = data.aws_iam_instance_profile.this.name

  tags = {
    Name        = "${var.proj}-ec2-${var.tag}"
    Environment = var.proj
  }
}
