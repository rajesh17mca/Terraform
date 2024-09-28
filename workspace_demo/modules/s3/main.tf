provider "aws" {
  region = "us-east-1"
}

variable "bucket_name_value" {
  description = "This is S3 Bucket Name"
  default = "bucket_s3_dev"
}

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = var.bucket_name_value
}

output "s3_bucket_output" {
  value = aws_s3_bucket.aws_s3_bucket.id
}