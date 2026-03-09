terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.35.1"
    }
  }
}

provider "aws" {

  region = "ap-south-1"

}

variable "ins_name" {
  description = "This is instance Name"
  type        = string
  default     = "TF-SERVER-CREATION"

}

variable "ins_type" {
  description = "this is default instance type for free tier"
  type        = string
  default     = "t2.micro"
}

variable "ins_ami" {
  description = "this is default ami for linux server"
  type        = string
  default     = "ami-06c643a49c853da56"

}

variable "ins_key" {
  description = "this default key pair for this server"
  type        = string
  default     = "tarunpem5/02/2025"

}

resource "aws_instance" "my_instance" {
  ami           = var.ins_ami
  instance_type = var.ins_type
  key_name      = var.ins_key
  tags = {
    Name = var.ins_name

  }
}
