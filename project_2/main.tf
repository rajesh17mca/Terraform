provider "aws" {
    region = "us-east-1"
}

module "ec2_module" {
  source = "./modules/ec2"
  ami_value = "ami-0ebfd941bbafe70c6"
  instance_type_value = "t2.micro"
}

module "s3_module" {
  source = "./modules/s3"
}