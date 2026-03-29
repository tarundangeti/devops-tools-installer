resource "aws_instance" "tf_instance" {
  instance_type = var.instance_type
  ami = var.instance_ami
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name = var.key_name
  tags = {
    Name = var.instance_name
  }
}
