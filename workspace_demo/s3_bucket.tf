variable "bucket_name_value_root" {
  description = "S3 Bucket name from root"
}

module "s3_bucket" {
  source = "./modules/s3"
  bucket_name_value = "${var.bucket_name_value_root}-${terraform.workspace}"
}

output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_output
}