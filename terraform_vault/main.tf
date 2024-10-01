provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://54.242.77.181:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"
    parameters = {
        role_id = "8276a0c9-de4e-bfc8-0009-101014b5d9fe"
        secret_id = "b7f6c15a-9fbb-08e0-93e4-f5052b832bcd"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "rajesh"
  name  = "test-secret"
}

resource "aws_instance" "ec2_instance" {
  ami = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  tags = {
    "name" = "secret-demo"
    "secret_data" = data.vault_kv_secret_v2.example.data["username"]
  }
}