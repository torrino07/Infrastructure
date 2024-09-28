resource "aws_iam_role" "s3_role" {
  name = "s3_role"

  assume_role_policy = file("${var.policy_path}/assume_role_policy.json")
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.s3_role.id

  policy = file("${var.policy_path}/s3_policy.json")
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = aws_iam_role.s3_role.name
}
