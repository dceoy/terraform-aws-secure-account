resource "aws_config_configuration_recorder" "config" {
  name     = "${var.system_name}-${var.env_type}-config-recorder"
  role_arn = aws_iam_role.config.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config" {
  depends_on     = [aws_config_configuration_recorder.config]
  name           = "${var.system_name}-${var.env_type}-config-delivery-channel"
  s3_bucket_name = var.s3_bucket_id
  s3_key_prefix  = var.config_s3_key_prefix
  s3_kms_key_arn = var.s3_kms_key_arn
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
}

resource "aws_config_configuration_recorder_status" "config" {
  depends_on = [aws_config_delivery_channel.config]
  name       = aws_config_configuration_recorder.config.name
  is_enabled = true
}

resource "aws_iam_role" "config" {
  name                  = "${var.system_name}-${var.env_type}-config-iam-role"
  description           = "AWS Config IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ConfigAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = ["sts:AssumeRole"]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-config-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role_policy" "config" {
  name = "${var.system_name}-${var.env_type}-config-iam-role-policy"
  role = aws_iam_role.config.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ConfigGetS3BucketAcl"
        Effect   = "Allow"
        Action   = ["s3:GetBucketAcl"]
        Resource = ["arn:aws:s3:::${var.s3_bucket_id}"]
      },
      {
        Sid      = "ConfigPutS3Objects"
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = ["arn:aws:s3:::${var.s3_bucket_id}/${var.config_s3_key_prefix}/AWSLogs/${local.account_id}/Config/*"]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "aws:SourceAccount" = local.account_id
          }
        }
      },
      {
        Sid    = "ConfigEncryptAndDecryptS3Objects"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = var.s3_kms_key_arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
}

resource "aws_config_config_rule" "root_mfa" {
  depends_on  = [aws_config_configuration_recorder.config]
  name        = "${var.system_name}-${var.env_type}-config-root-mfa-rule"
  description = "Checks if the root user of the AWS account requires MFA for console sign-in"
  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-config-root-mfa-rule"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_config_config_rule" "user_mfa" {
  depends_on  = [aws_config_configuration_recorder.config]
  name        = "${var.system_name}-${var.env_type}-config-user-mfa-rule"
  description = var.allow_non_console_access_without_mfa ? "Checks if the IAM users have MFA enabled" : "Checks if MFA is enabled for all IAM users that use a console password"
  source {
    owner             = "AWS"
    source_identifier = var.allow_non_console_access_without_mfa ? "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS" : "IAM_USER_MFA_ENABLED"
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-config-user-mfa-rule"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
