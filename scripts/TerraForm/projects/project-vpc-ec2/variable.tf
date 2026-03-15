variable "instance_type" {
  description = "this is deafult instance type for free tier account"
  type        = string
  default     = ""
}

variable "ami" {
  description = "this is ubuntu latest image for this project"
  type        = string
  default     = ""
}

variable "instance_first_name" {
  description = "this is first instance name"
  type        = string
  default     = ""
}

variable "instance_second_name" {
  description = "this is second instance name"
  type        = string
  default     = ""
}


variable "vpc_cidr" {
  description = "this is vpc cidr"
  type        = string
  default     = ""
}

variable "subnet1_cidr" {
  description = "this is vpc subnet cidr"
  type        = string
  default     = ""
}

variable "subnet2_cidr" {
  description = "this is vpc subnet cidr"
  type        = string
  default     = ""

}
