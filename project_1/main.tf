provider "aws" {
    region = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instace Type"
  type = string
  default = "t2.micro"
}

variable "ami_value" {
  description = "AMI ID"
  type = string
  default = "ami-0ebfd941bbafe70c6"
}

resource "aws_instance" "example" {
  ami                     = var.ami_value
  instance_type           = var.instance_type
  tags = {
    "name" = "Rajesh"
    "org" = "Apple"
  }
}

output "ami_id_output" {
  description = "AMI from output variable"
  value = aws_instance.example.ami
}

output "public_ip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.example.public_ip
}
