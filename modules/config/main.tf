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
  sns_topic_arn  = aws_sns_topic.config.arn
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
}

resource "aws_iam_role" "config" {
  name = "${var.system_name}-${var.env_type}-config-iam-role"
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
            "AWS:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
  inline_policy {
    name = "${var.system_name}-${var.env_type}-config-iam-role-policy"
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
              "AWS:SourceAccount" = local.account_id
            }
          }
        },
        {
          Sid    = "ConfigEncryptAndDecryptS3Objects"
          Effect = "Allow"
          Action = [
            "kms:GenerateDataKey",
            "kms:Decrypt"
          ]
          Resource = var.s3_kms_key_arn
          Condition = {
            StringEquals = {
              "AWS:SourceAccount" = local.account_id
            }
          }
        }
      ]
    })
  }
}

resource "aws_sns_topic" "config" {
  name              = "${var.system_name}-${var.env_type}-config-sns-topic"
  display_name      = "${var.system_name}-${var.env_type}-config-sns-topic"
  kms_master_key_id = var.sns_kms_key_arn
  tags = {
    Name       = "${var.system_name}-${var.env_type}-config-sns-topic"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_sns_topic_policy" "config" {
  arn = aws_sns_topic.config.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_sns_topic.config.name}-policy"
    Statement = [
      {
        Sid    = "ConfigPublishSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = ["sns:Publish"]
        Resource = [aws_sns_topic.config.arn]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:config:*:${local.account_id}:*"
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
}

resource "aws_config_config_rule" "user_mfa" {
  depends_on  = [aws_config_configuration_recorder.config]
  name        = "${var.system_name}-${var.env_type}-config-user-mfa-rule"
  description = var.allow_non_console_access_without_mfa ? "Checks if the IAM users have MFA enabled" : "Checks if MFA is enabled for all IAM users that use a console password"
  source {
    owner             = "AWS"
    source_identifier = var.allow_non_console_access_without_mfa ? "MFA_ENABLED_FOR_IAM_CONSOLE_ACCESS" : "IAM_USER_MFA_ENABLED"
  }
}
