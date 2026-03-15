provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "192.168.0.0/16"
}

# Subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.my_route_table.id
}

# Security Group
resource "aws_security_group" "my_security_group" {
  name   = "my-security-group"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-security-group"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "terraform-s3-test-reya-project"
}

# EC2 Instances
resource "aws_instance" "server1" {
  instance_type          = var.instance_type
  ami                    = var.ami
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = base64encode(file("userdata.sh"))

  tags = {
    Name = "my-1st-server"
  }
}

resource "aws_instance" "server2" {
  instance_type          = var.instance_type
  ami                    = var.ami
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = base64encode(file("userdata.sh"))

  tags = {
    Name = "my-2nd-server"
  }
}

# Application Load Balancer
resource "aws_lb" "myalb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.my_security_group.id]
  subnets         = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "WEB-LB"
  }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# Attach Instances
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}
