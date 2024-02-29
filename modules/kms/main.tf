resource "aws_kms_key" "custom" {
  description             = "KMS key for S3 and SNS"
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
          StringLike = {
            "kms:ViaService" = "s3.*.amazonaws.com"
          }
          StringEquals = {
            "kms:CallerAccount" = local.account_id
          }
        }
      },
      {
        Sid    = "EventsEncryptAndDecryptSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = [
            "events.amazonaws.com",
            "config.amazonaws.com",
            "budgets.amazonaws.com"
          ]
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = [
              "arn:aws:events:*:${local.account_id}:*",
              "arn:aws:config:*:${local.account_id}:*",
              "arn:aws:budgets::${local.account_id}:*"
            ]
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
            "aws:SourceArn"                            = "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
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
          "kms:Decrypt",
          "kms:GenerateDataKey"
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
    Name       = "${var.system_name}-${var.env_type}-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "custom" {
  name          = "alias/${aws_kms_key.custom.tags.Name}"
  target_key_id = aws_kms_key.custom.arn
}
