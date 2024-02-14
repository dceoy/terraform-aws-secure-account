resource "aws_s3_bucket" "base" {
  bucket        = local.base_s3_bucket_name
  force_destroy = true
  tags = {
    Name       = local.base_s3_bucket_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

# tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "accesslog" {
  bucket        = local.accesslog_s3_bucket_name
  force_destroy = true
  tags = {
    Name       = local.accesslog_s3_bucket_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_s3_bucket_logging" "base" {
  bucket        = aws_s3_bucket.base.id
  target_bucket = aws_s3_bucket.accesslog.id
  target_prefix = "${aws_s3_bucket.base.id}/"
}

resource "aws_s3_bucket_public_access_block" "base" {
  bucket                  = aws_s3_bucket.base.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "accesslog" {
  bucket                  = aws_s3_bucket.accesslog.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "base" {
  bucket = aws_s3_bucket.base.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.common.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "accesslog" {
  bucket = aws_s3_bucket.accesslog.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.common.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "base" {
  bucket = aws_s3_bucket.base.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "accesslog" {
  bucket = aws_s3_bucket.accesslog.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "base" {
  bucket = aws_s3_bucket.base.id
  rule {
    status = "Enabled"
    id     = "Move-to-Intelligent-Tiering-after-0day"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "accesslog" {
  bucket = aws_s3_bucket.accesslog.id
  rule {
    status = "Enabled"
    id     = "Move-to-Intelligent-Tiering-after-0day"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_policy" "base" {
  bucket = aws_s3_bucket.base.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = ["s3:GetBucketAcl"]
        Resource = aws_s3_bucket.base.arn
        Condition = {
          StringLike = {
            "aws:SourceArn" = "arn:${local.partition}:cloudtrail:${local.region}:${local.account_id}:trail/*"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.base.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          },
          StringLike = {
            "aws:SourceArn" = "arn:${local.partition}:cloudtrail:${local.region}:${local.account_id}:trail/*"
          }
        }
      },
      {
        Sid       = "DenyUnencryptedObjectUploads"
        Effect    = "Deny"
        Principal = "*"
        Action    = ["s3:*"]
        Resource = [
          aws_s3_bucket.base.arn,
          "${aws_s3_bucket.base.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "accesslog" {
  bucket = aws_s3_bucket.accesslog.arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3ServerAccessLogsPolicy"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.system_name}-${var.env_type}-*/*"
        Condition = {
          ArnLike = {
            "aws:SourceArn" : "arn:aws:s3:::${var.system_name}-${var.env_type}-*"
          },
          StringEquals = {
            "aws:SourceAccount" : local.account_id
          }
        }
      },
      {
        Sid       = "DenyUnencryptedObjectUploads"
        Effect    = "Deny"
        Principal = "*"
        Action    = ["s3:*"]
        Resource = [
          aws_s3_bucket.accesslog.arn,
          "${aws_s3_bucket.accesslog.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_kms_key" "common" {
  description             = "KMS key for encrypting S3 bucket objects"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Name       = "${var.system_name}-${var.env_type}-s3-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "common" {
  name          = "alias/${aws_kms_key.common.tags.Name}"
  target_key_id = aws_kms_key.common.arn
}

resource "aws_s3control_storage_lens_configuration" "common" {
  count      = var.enable_s3_storage_lens ? 1 : 0
  config_id  = "${var.system_name}-${var.env_type}-s3-storage-lens-configuration"
  account_id = local.account_id
  storage_lens_configuration {
    enabled = true
    account_level {
      activity_metrics {
        enabled = true
      }
      advanced_cost_optimization_metrics {
        enabled = true
      }
      advanced_data_protection_metrics {
        enabled = true
      }
      detailed_status_code_metrics {
        enabled = true
      }
      bucket_level {
        activity_metrics {
          enabled = true
        }
        advanced_cost_optimization_metrics {
          enabled = true
        }
        advanced_data_protection_metrics {
          enabled = true
        }
        detailed_status_code_metrics {
          enabled = true
        }
        prefix_level {
          storage_metrics {
            enabled = true
          }
        }
      }
    }
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-s3-storage-lens-configuration"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
