terraform {
backend "s3" {
    bucket         = "my-terraform-state-bucket"   # bucket must already exist
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"       # DynamoDB table must exist
  }
}
