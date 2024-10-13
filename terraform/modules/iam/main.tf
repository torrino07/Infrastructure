resource "aws_iam_role" "this" {
  name = "${var.environment}-${var.name}-iam-role"
  assume_role_policy = file("${var.assume_role_policy_path}")
}

resource "aws_iam_role_policy" "ec2_inline_policy" {
  name   =  "${var.environment}-${var.name}-iam-role-policy"
  role   = aws_iam_role.this.id
  policy = file("${var.policy_path}")
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}-${var.name}-profile"
  role = aws_iam_role.this.name
}