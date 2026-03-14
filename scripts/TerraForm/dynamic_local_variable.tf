provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "myinstance" {

  instance_type = terraform.workspace == "prod" ? "t2.small" : "t2.micro"

  key_name = "your-keypair-name"
  ami      = "ami-0f58b397bc5c1f2e8"

  tags = {
    Name = "${terraform.workspace}-dynamicinstancetyped-server"
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
