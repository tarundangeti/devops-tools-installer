terraform {
  backend "s3" {
    bucket = "tarun-terraform-tfstate-bucket"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
