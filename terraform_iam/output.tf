output "user_name" {
  value = aws_iam_user.iam_user[0].id
}

output "console_password" {
  value = aws_iam_user_login_profile.iam_user_login[0].password
}

output "iam_user_data" {
  value = data.aws_iam_user.iam_user_data
}

output "iam_policy_data" {
  value = data.aws_iam_policy.iam_user_data
}