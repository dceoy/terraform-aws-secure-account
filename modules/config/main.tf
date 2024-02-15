resource "aws_config_configuration_recorder" "base" {
  name     = "${var.system_name}-${var.env_type}-config-recorder"
  role_arn = aws_iam_role.base.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "base" {
  depends_on     = [aws_config_configuration_recorder.base]
  name           = "${var.system_name}-${var.env_type}-config-delivery-channel"
  s3_bucket_name = var.s3_bucket_id
  s3_key_prefix  = "config/awslabs/${local.account_id}/"
  s3_kms_key_arn = var.s3_kms_key_arn
  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }
}

resource "aws_iam_role" "base" {
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
          Sid    = "ConfigPutS3Objects"
          Effect = "Allow"
          Action = [
            "s3:PutObject",
            "s3:PutObjectAcl"
          ]
          Resource = ["arn:aws:s3:::${var.s3_bucket_id}/*"],
          Condition = {
            StringLike = {
              "s3:x-amz-acl" = "bucket-owner-full-control"
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
