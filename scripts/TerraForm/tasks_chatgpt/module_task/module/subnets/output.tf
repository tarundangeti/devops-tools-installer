output "public_ids" {
  value = [aws_subnet.tf_public_subnet1.id, aws_subnet.tf_public_subnet2.id]
}

output "private_ids" {
  value = [aws_subnet.tf_private_subnet1.id, aws_subnet.tf_private_subnet2.id]
}
