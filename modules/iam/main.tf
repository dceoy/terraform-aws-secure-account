resource "aws_iam_account_alias" "account" {
  count         = var.account_alias != null ? 1 : 0
  account_alias = var.account_alias
}

# tfsec:ignore:aws-iam-no-password-reuse
# tfsec:ignore:aws-iam-set-max-password-age
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  allow_users_to_change_password = true
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
}

resource "aws_accessanalyzer_analyzer" "account" {
  count         = var.enable_iam_accessanalyzer ? 1 : 0
  analyzer_name = "${var.system_name}-${var.env_type}-account-accessanalyzer"
  type          = "ACCOUNT"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-account-accessanalyzer"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "cloudformation_stackset_administration" {
  name = "${var.system_name}-${var.env_type}-cloudformation-stackset-administration-iam-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudFormationAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudformation.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  inline_policy {
    name = "${var.system_name}-${var.env_type}-cloudformation-stackset-administration-iam-role-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "CloudFormationStackSetAdministration"
          Effect   = "Allow"
          Action   = ["sts:AssumeRole"]
          Resource = [aws_iam_role.cloudformation_stackset_execution.arn]
        }
      ]
    })
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-cloudformation-stackset-administration-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "cloudformation_stackset_execution" {
  name = "${var.system_name}-${var.env_type}-cloudformation-stackset-execution-iam-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "UserAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  tags = {
    Name       = "${var.system_name}-${var.env_type}-cloudformation-stackset-execution-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "administrator" {
  name = "${var.system_name}-${var.env_type}-administrator-iam-role"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "UserAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action = ["sts:AssumeRole"]
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  tags = {
    Name       = "${var.system_name}-${var.env_type}-administrator-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_policy" "administrator" {
  name        = "${var.system_name}-${var.env_type}-administrator-switch-iam-policy"
  description = "Administrator switch IAM Policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "UserAssumeAccountRoles"
        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Resource = ["arn:aws:iam::${local.account_id}:role/*"]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "developer" {
  name        = "${var.system_name}-${var.env_type}-developer-switch-iam-policy"
  description = "developer switch IAM Policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "UserAssumeAccountRoles"
        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Resource = "arn:aws:iam::${local.account_id}:role/*"
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
          StringEquals = {
            "aws:ResourceTag/SwitchAllowedPolicy" = "${var.system_name}-${var.env_type}-developer-switch-iam-policy"
          }
        }
      }
    ]
  })
}

# tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "mfa" {
  name        = "${var.system_name}-${var.env_type}-user-mfa-iam-policy"
  description = "User MFA IAM Policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListActions"
        Effect = "Allow"
        Action = [
          "iam:ListUsers",
          "iam:ListVirtualMFADevices"
        ]
        Resource = "*"
      },
      {
        Sid      = "AllowUserToCreateVirtualMFADevice"
        Effect   = "Allow"
        Action   = ["iam:CreateVirtualMFADevice"]
        Resource = ["arn:aws:iam::*:mfa/*"]
      },
      {
        Sid    = "AllowUserToManageTheirOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:EnableMFADevice",
          "iam:GetMFADevice",
          "iam:ListMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = ["arn:aws:iam::*:user/$${aws:username}"]
      },
      {
        Sid      = "AllowUserToDeactivateTheirOwnMFAOnlyWhenUsingMFA"
        Effect   = "Allow"
        Action   = ["iam:DeactivateMFADevice"]
        Resource = ["arn:aws:iam::*:user/$${aws:username}"]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" = "true"
          }
        }
      },
      {
        Sid    = "BlockMostAccessUnlessSignedInWithMFA"
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListMFADevices",
          "iam:ListUsers",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-user-mfa-iam-policy"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

# tfsec:ignore:aws-iam-enforce-group-mfa
resource "aws_iam_group" "administrator" {
  name = "${var.system_name}-${var.env_type}-administrator-iam-group"
  path = "/"
}

# tfsec:ignore:aws-iam-enforce-group-mfa
resource "aws_iam_group" "developer" {
  name = "${var.system_name}-${var.env_type}-developer-iam-group"
  path = "/"
}

# tfsec:ignore:aws-iam-enforce-group-mfa
resource "aws_iam_group" "readonly" {
  name = "${var.system_name}-${var.env_type}-readonly-iam-group"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "administrator" {
  group      = aws_iam_group.administrator.name
  policy_arn = aws_iam_policy.administrator.arn
}

resource "aws_iam_group_policy_attachment" "developer" {
  group      = aws_iam_group.developer.name
  policy_arn = aws_iam_policy.developer.arn
}

resource "aws_iam_group_policy_attachment" "readonly" {
  for_each = toset([
    aws_iam_group.administrator.name,
    aws_iam_group.readonly.name
  ])
  group      = each.key
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "mfa" {
  for_each = toset([
    aws_iam_group.administrator.name,
    aws_iam_group.developer.name,
    aws_iam_group.readonly.name
  ])
  group      = each.key
  policy_arn = aws_iam_policy.mfa.arn
}

resource "aws_iam_group_policy_attachment" "password" {
  for_each = toset([
    aws_iam_group.administrator.name,
    aws_iam_group.developer.name,
    aws_iam_group.readonly.name
  ])
  group      = each.key
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_policy_attachment" "credential" {
  for_each = toset([
    aws_iam_group.administrator.name,
    aws_iam_group.developer.name,
    aws_iam_group.readonly.name
  ])
  group      = each.key
  policy_arn = "arn:aws:iam::aws:policy/IAMSelfManageServiceSpecificCredentials"
}

resource "aws_iam_user" "users" {
  for_each = toset(
    concat(
      var.administrator_iam_user_names,
      var.developer_iam_user_names,
      var.readonly_iam_user_names
    )
  )
  name          = each.key
  path          = "/"
  force_destroy = var.iam_force_destroy
  tags = {
    Name       = each.key
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_user_group_membership" "administrator" {
  depends_on = [aws_iam_user.users]
  for_each   = toset(var.administrator_iam_user_names)
  user       = each.key
  groups     = [aws_iam_group.administrator.name]
}

resource "aws_iam_user_group_membership" "developer" {
  depends_on = [aws_iam_user.users]
  for_each   = toset(var.developer_iam_user_names)
  user       = each.key
  groups     = [aws_iam_group.developer.name]
}

resource "aws_iam_user_group_membership" "readonly" {
  depends_on = [aws_iam_user.users]
  for_each   = toset(var.readonly_iam_user_names)
  user       = each.key
  groups     = [aws_iam_group.readonly.name]
}
