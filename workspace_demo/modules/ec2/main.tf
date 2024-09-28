provider "aws" {
  region = "us-east-1"
}

variable "ami_value" {
  description = "This is AMI for the Ec2 Instacne"
  default = "ami-0ebfd941bbafe70c6"
}

variable "instance_type_value" {
  description = "This is Instance type"
}

resource "aws_instance" "ec2_instance" {
  ami = var.ami_value
  instance_type = var.instance_type_value
}