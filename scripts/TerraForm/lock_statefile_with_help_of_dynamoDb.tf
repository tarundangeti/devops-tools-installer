provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"   # bucket must already exist
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"       # DynamoDB table must exist
  }
}

resource "aws_instance" "myinstance" {
  instance_type = "t2.micro"
  ami           = "ami-0f58b397bc5c1f2e8"
  key_name      = "my-key"

  tags = {
    Name = "instance-prod-1"
  }
}
