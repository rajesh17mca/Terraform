provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "iam_user" {
  count = var.create_user ? 1 : 0

  name = var.iam_user_name
  force_destroy = true
  path = "/"
}

resource "aws_iam_user_login_profile" "iam_user_login" {
  count = var.enable_login_profile ? 1 : 0
 
  user = aws_iam_user.iam_user[0].name
  password_length = 16
  password_reset_required = true
}

resource "aws_iam_policy" "iam_user_policy" {
  name        = "rajesh-kamireddy-policy"
  description = "Policy to manage Rajesh Kamireddy user"
  policy      = <<EOF
                {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                        "Action": [
                            "iam:ChangePassword",
                            "s3:Get*",
                            "s3:List*",
                            "s3:Describe*"
                        ],
                        "Effect": "Allow",
                        "Resource": "*"
                        }
                    ]
                }
                EOF
  tags = {
    name = aws_iam_user.iam_user[0].id
  }
}

variable "policies_arn" {
  type = set(string)
  default = [ "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonVPCFullAccess", "arn:aws:iam::aws:policy/job-function/Billing" ]
}

resource "aws_iam_user_policy_attachment" "default_policy" {
  user = aws_iam_user.iam_user[0].id
  for_each = var.policies_arn
  policy_arn = each.key
}

resource "aws_iam_user_policy_attachment" "iam_policy_attach" {
  policy_arn = aws_iam_policy.iam_user_policy.arn
  user = aws_iam_user.iam_user[0].id
}

data "aws_iam_user" "iam_user_data" {
  user_name = "rajesh.kamireddy"
}

data "aws_iam_policy" "iam_user_data" {
  name = "rajesh-kamireddy-policy"
}