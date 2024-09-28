provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_remote_backend" {
    ami = "ami-0ebfd941bbafe70c6"
    instance_type = "t2.micro"
    tags = {
        "name" = "rajesh_remote_backend_ec2"
        "org" = "apple_ec2_instance"
    }
}   

output "public_ip_address" {
  value = aws_instance.ec2_remote_backend.public_ip
}

resource "aws_s3_bucket" "rajesh_s3_bucket" {
  bucket = "rajesh-remote-backend"
}

resource "aws_dynamodb_table" "aws_dynamodb_table_lock" {
  name = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}