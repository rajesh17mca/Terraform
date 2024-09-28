provider "aws" {
  region = "us-east-1"
}

variable "ami_value_root" {
  description = "This is AMI for the Ec2 Instacne"
}

variable "instance_type_value_root" {
  description = "This is Instance type"
  type = map(string)
  default = {
    "prod" = "t2.large",
    "dev" = "t2.micro",
    "stage" = "t2.midum"
  }
}

module "ec2_instance" {
  source = "./modules/ec2"
  instance_type_value = lookup(var.instance_type_value_root, terraform.workspace, "t2.micro")
}