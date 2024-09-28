terraform {
  backend "s3" {
    bucket = "rajesh-remote-backend"
    key    = "rajesh/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
