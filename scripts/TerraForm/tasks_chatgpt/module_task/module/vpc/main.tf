resource "aws_vpc" "tf_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_Name
  }
}
