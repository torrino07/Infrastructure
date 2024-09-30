terraform {
    backend "s3" {
        bucket         = "terraformstate001"
        key            = "${terraform.workspace}/terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "terraform-locks"
        encrypt        = true
    }
}
