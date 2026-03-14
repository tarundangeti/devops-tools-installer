terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "myvpc_tf"
  }
}

# Subnet
resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "mysubnet_tf"
  }
}

# EC2 Instance
resource "aws_instance" "myinstance" {
  ami           = "ami-0f58b397bc5c1f2e8"   # Amazon Linux AMI (example for ap-south-1)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mysubnet.id
  key_name      = "your-keypair-name"

  tags = {
    Name = "myinstance"
  }
}
