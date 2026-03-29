resource "aws_subnet" "tf_public_subnet1" {
  vpc_id = var.vpc_id
  cidr_block = var.tf_public_subnet_cidr1
  availability_zone = var.public_az1
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name1
  }
}
resource "aws_subnet" "tf_public_subnet2" {
  vpc_id = var.vpc_id
  cidr_block = var.tf_public_subnet_cidr2
  availability_zone = var.public_az2
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name2
  }
}

resource "aws_subnet" "tf_private_subnet1" {
  vpc_id = var.vpc_id
  cidr_block = var.tf_private_cidr1
  availabillity_zone = var.private_az1
  tags = {
    Name = var.private_subnet_name1
  }
}

resource "aws_subnet" "tf_private_subnet2" {
  vpc_id = var.vpc_id
  cidr_block = var.tf_private_cidr2
  availabillity_zone = var.private_az2
  tags = {
    Name = var.private_subnet_name2
  }
}
