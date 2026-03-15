variable "instance_first_name" {
  description = "Name of the first EC2 instance"
  type        = string
}

variable "instance_second_name" {
  description = "Name of the second EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}
