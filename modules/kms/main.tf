resource "aws_kms_key" "s3" {
  description             = "KMS key for encrypting S3 bucket objects"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "UserAccessKMS"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action   = ["kms:*"]
        Resource = "*"
      },
      {
        Sid    = "S3EncryptS3AccessLogs"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService"    = "s3.${local.region}.amazonaws.com"
            "kms:CallerAccount" = local.account_id
          }
        }
      },
      {
        Sid    = "CloudTrailEncryptCloudTrailLogs"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = ["kms:GenerateDataKey*"]
        Resource = "*"
        Condition = {
          ArnLike = {
            "aws:SourceArn"                            = "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/*"
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
          }
        }
      },
      {
        Sid    = "ConfigEncryptConfigLogs"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-s3-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "s3" {
  name          = "alias/${aws_kms_key.s3.tags.Name}"
  target_key_id = aws_kms_key.s3.arn
}

resource "aws_kms_key" "sns" {
  count = (
    var.enable_guardduty || var.enable_config || var.enable_budgets
  ) ? 1 : 0
  description             = "KMS key for encrypting SNS messages"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "UserAccessKMS"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action   = ["kms:*"]
        Resource = "*"
      },
      {
        Sid    = "EventsEncryptAndDecryptSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = compact([
            var.enable_guardduty ? "guardduty.amazonaws.com" : null,
            var.enable_config ? "config.amazonaws.com" : null,
            var.enable_budgets ? "budgets.amazonaws.com" : null
          ])
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:events:*:${local.account_id}:*"
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-sns-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "sns" {
  count         = length(aws_kms_key.sns) > 0 ? 1 : 0
  name          = "alias/${aws_kms_key.sns[0].tags.Name}"
  target_key_id = aws_kms_key.sns[0].arn
}
