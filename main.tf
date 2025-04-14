# main.tf

locals {
  user_definitions = {
    system_admin = [
      "system_admin_1",
      "system_admin_2",
      "system_admin_3"
    ]
    database_admin = [
      "database_admin_1",
      "database_admin_2",
      "database_admin_3"
    ]
    read_only = [
      "read_only_1",
      "read_only_2",
      "read_only_3"
    ]
  }

  group_policy_map = {
    system_admin   = "arn:aws:iam::aws:policy/AdministratorAccess"
    database_admin = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
    read_only      = "arn:aws:iam::aws:policy/AmazonConnectReadOnlyAccess"
  }
}

# Step 1: Create IAM Users
resource "aws_iam_user" "users" {
  for_each = merge(
    { for user in local.user_definitions.system_admin : user => "system_admin" },
    { for user in local.user_definitions.database_admin : user => "database_admin" },
    { for user in local.user_definitions.read_only : user => "read_only" }
  )

  name = each.key
  path = "/users/"
}

# Step 2: Create Login Profiles
resource "aws_iam_user_login_profile" "login_profiles" {
  for_each = aws_iam_user.users

  user                    = each.key
  password_length         = var.password_length
  password_reset_required = true
}

# Step 3: Create IAM Groups
resource "aws_iam_group" "groups" {
  for_each = local.group_policy_map

  name = "${each.key}_group"
  path = "/users/"
}

# Step 4: Assign Users to Groups (Corrected)
resource "aws_iam_user_group_membership" "devops" {
  for_each = merge(
    { for user in local.user_definitions.system_admin : user => "system_admin" },
    { for user in local.user_definitions.database_admin : user => "database_admin" },
    { for user in local.user_definitions.read_only : user => "read_only" }
  )

  user   = aws_iam_user.users[each.key].name
  groups = [aws_iam_group.groups[each.value].name]  # Use 'groups' (plural)
}


# Step 5: Assign Permissions (Policies)
resource "aws_iam_group_policy_attachment" "group_policies" {
  for_each = local.group_policy_map

  group      = aws_iam_group.groups[each.key].name
  policy_arn = each.value
}

# Step 6: Set Account Password Policy
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = var.minimum_password_length
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}
