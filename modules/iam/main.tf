resource "aws_iam_account_alias" "account" {
  count         = var.account_alias != null ? 1 : 0
  account_alias = var.account_alias
}

# trivy:ignore:AVD-AWS-0056
# trivy:ignore:AVD-AWS-0062
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
  name                  = "${var.system_name}-${var.env_type}-cloudformation-stackset-administration-iam-role"
  description           = "CloudFormation stackset administration IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
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
  name                  = "${var.system_name}-${var.env_type}-cloudformation-stackset-execution-iam-role"
  description           = "CloudFormation stackset execution IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
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
  name                  = "${var.system_name}-${var.env_type}-administrator-iam-role"
  description           = "Administrator IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
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
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration = var.iam_role_max_session_duration
  tags = {
    Name       = "${var.system_name}-${var.env_type}-administrator-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_policy" "administrator" {
  name        = "${var.system_name}-${var.env_type}-administrator-switch-iam-policy"
  description = "Administrator switch IAM policy"
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
  description = "Developer switch IAM policy"
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
          StringEquals = {
            "aws:ResourceTag/SwitchAllowedPolicy" = "${var.system_name}-${var.env_type}-developer-switch-iam-policy"
          }
        }
      }
    ]
  })
}

# trivy:ignore:AVD-AWS-0057
resource "aws_iam_policy" "mfa" {
  name        = "${var.system_name}-${var.env_type}-user-mfa-iam-policy"
  description = "User MFA IAM policy"
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

# trivy:ignore:AVD-AWS-0057
resource "aws_iam_policy" "activate" {
  name        = "${var.system_name}-${var.env_type}-activate-fullaccess-iam-policy"
  description = "Activate full access IAM policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowActivateActions"
        Effect   = "Allow"
        Action   = ["activate:*"]
        Resource = "*"
      }
    ]
  })
}

# trivy:ignore:AVD-AWS-0123
resource "aws_iam_group" "administrator" {
  name = "${var.system_name}-${var.env_type}-administrator-iam-group"
  path = "/"
}

# trivy:ignore:AVD-AWS-0123
resource "aws_iam_group" "developer" {
  name = "${var.system_name}-${var.env_type}-developer-iam-group"
  path = "/"
}

# trivy:ignore:AVD-AWS-0123
resource "aws_iam_group" "readonly" {
  name = "${var.system_name}-${var.env_type}-readonly-iam-group"
  path = "/"
}

# trivy:ignore:AVD-AWS-0123
resource "aws_iam_group" "activate" {
  name = "${var.system_name}-${var.env_type}-activate-iam-group"
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

resource "aws_iam_group_policy_attachment" "activate" {
  group      = aws_iam_group.activate.name
  policy_arn = aws_iam_policy.activate.arn
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
  force_destroy = var.iam_user_force_destroy
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

resource "aws_iam_user_group_membership" "activate" {
  depends_on = [aws_iam_user.users]
  for_each   = toset(var.activate_iam_user_names)
  user       = each.key
  groups     = [aws_iam_group.activate.name]
}

resource "aws_iam_openid_connect_provider" "github" {
  count           = length(var.github_repositories_requiring_oidc) > 0 ? 1 : 0
  url             = var.github_enterprise_slug != null ? "https://token.actions.githubusercontent.com/${var.github_enterprise_slug}" : "https://token.actions.githubusercontent.com"
  thumbprint_list = [local.tls_certificate_sha1_fingerprint]
  client_id_list = setunion(
    toset(["sts.amazonaws.com"]),
    toset([for r in var.github_repositories_requiring_oidc : "https://github.com/${split("/", r)[0]}"])
  )
  tags = {
    Name       = "${var.system_name}-${var.env_type}-github-iam-oidc-provider"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "github" {
  count                 = length(aws_iam_openid_connect_provider.github) > 0 ? 1 : 0
  name                  = "${var.system_name}-${var.env_type}-github-iam-oidc-provider-iam-role"
  description           = "GitHub OIDC provider IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.github_enterprise_slug != null ? "${aws_iam_openid_connect_provider.github[0].arn}/${var.github_enterprise_slug}" : aws_iam_openid_connect_provider.github[0].arn
        }
        Action = ["sts:AssumeRoleWithWebIdentity"]
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              for r in var.github_repositories_requiring_oidc : "repo:${r}:*"
            ]
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
  managed_policy_arns = var.github_iam_oidc_provider_iam_policy_arns
  tags = {
    Name       = "${var.system_name}-${var.env_type}-github-iam-oidc-provider-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
