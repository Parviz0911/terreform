# outputs.tf

output "user_names" {
  value = aws_iam_user.users
}

output "group_names" {
  value = aws_iam_group.groups
}
