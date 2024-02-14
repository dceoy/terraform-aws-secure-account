# tfsec:ignore:aws-cloudtrail-ensure-cloudwatch-integration:
resource "aws_cloudtrail" "base" {
  name                          = local.cloudtrail_trail_name
  enable_logging                = true
  include_global_service_events = true
  s3_bucket_name                = local.s3_bucket_id
  s3_key_prefix                 = "cloudtrail/awslogs/${local.account_id}/"
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.base.arn
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  tags = {
    Name       = local.cloudtrail_trail_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_key" "base" {
  description             = "KMS key for encrypting CloudTrail Logs"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow CloudWatch to encrypt logs"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceArn" : "arn:aws:cloudtrail:${local.region}:${local.account_id}:trail/${local.cloudtrail_trail_name}"
          },
          StringLike = {
            "kms:EncryptionContext:aws:cloudtrail:arn" : "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${local.cloudtrail_trail_name}-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "base" {
  name          = "alias/${aws_kms_key.base.tags.Name}"
  target_key_id = aws_kms_key.base.arn
}
