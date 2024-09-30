terraform {
    backend "s3" {
        bucket         = "terraformstate001"
        region         = "us-east-1"
        dynamodb_table = "terraform-locks"
        encrypt        = true
    }
}
