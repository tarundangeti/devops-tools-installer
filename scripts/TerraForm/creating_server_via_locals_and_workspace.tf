provider "aws" {
  region = "ap-south-1"
}

locals {
  instance_types = {
    dev  = "t2.micro"
    test = "t2.medium"
    prod = "t2.small"
  }
}

resource "aws_instance" "myinstance" {
  instance_type = local.instance_types[terraform.workspace]
  key_name      = "your-keypair-name"
  ami           = "ami-0f58b397bc5c1f2e8"

  tags = {
    Name = "${terraform.workspace}-server"
  }
}

output "instance_name" {
  value = aws_instance.myinstance.tags["Name"]
}

output "instance_type" {
  value = aws_instance.myinstance.instance_type
}

output "instance_workspace" {
  value = terraform.workspace
}
