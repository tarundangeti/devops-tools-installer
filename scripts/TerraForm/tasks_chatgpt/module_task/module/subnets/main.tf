resource "aws_subnet" "tf_public_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.tf_public_subnet_cidr
  availability_zone = var.public_az
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "tf_private_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.tf_private_cidr
  availabillity_zone = var.private_az
  tags = {
    Name = var.private_subnet_name
  }
}
