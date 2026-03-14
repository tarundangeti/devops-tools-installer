provider "aws" {
  region = "ap-south-1"
}

# Create S3 bucket for Terraform state
resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "tarun-terraform-tfstate-bucket"

  tags = {
    Name = "terraform-state-bucket"
  }
}

# Enable versioning (recommended)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
