variable "create_user" {
  description = "Whether to create the IAM user"
  type        = bool
  default     = true
}

variable "enable_login_profile" {
  description = "Whether to Enable console access to the IAM user"
  type        = bool
  default     = true
}

variable "iam_user_name" {
  default     = "rajesh.kamireddy"
}