vi version.tf
-----
terraform {
  required_providers {
  aws = {
    source = "hashicorp/aws"
    version = "6.38.0"
    }
  }
}
-----

vi provider.tf
-----
provider "aws" {
  region = "ap-south-1"
}
-----

vi variable.tf
-----
variable "instance_type" {
  type = string
}

variable "instance_ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags_Name" {
  type = string
}
------

vi terraform.tfvars
-------
instance_type = "t2.micro"
instance_ami = "ami-0c3d1e0f8ec487d6d"
key_name = "tarunpem5/02/2025"
tags_Name = "tf-server"

-------

vi main.tf
-------
resource "aws_instance" "my_instance" {
  instance_type = var.instance_type
  ami = var.instance_ami
  key_name = var.key_name
  tags = {
    Name = var.tags_Name
  }
}
------

vi output.tf
------
output "aws_instance_id" {
  value = aws_instance.my_instance.id
}

output "aws_instance_publicip" {
  value = aws_instance.my_instance.public_ip
}

output "aws_instance_key_name" {
  value = aws_instance.my_instance.key_name
}

output "aws_instance_Name" {
  value = aws_instance.my_instance.tags.Name
}

------
