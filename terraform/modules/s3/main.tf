resource "aws_s3_bucket_policy" "artifactstore_policy" {
  bucket = var.bucket
  policy = jsonencode(var.policy)
}