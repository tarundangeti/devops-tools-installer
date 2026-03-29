resource "aws_instance" "my_instance" {
  instance_type = "t2.small" # changing from t2.micro to t2.small
  ami = "ami-0c3d1e0f8ec487d6d"
  key_name = "tarunpem5/02/2025"
  tags = {
    Name = "Dev" # adding the name tag for the server
  }
}
