provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "rajesh-terraform-testing-bucket"

  tags = {
    Name        = "Rajesh bucket"
    Environment = "Dev"
  }
}