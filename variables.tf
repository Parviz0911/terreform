# variables.tf
variable "password_length" {
  description = "Length of the generated password for IAM users"
  type        = number
  default     = 16
}

variable "minimum_password_length" {
  description = "Minimum length of the account password"
  type        = number
  default     = 8
}
