resource "aws_s3_bucket" "base" {
  bucket        = local.base_s3_bucket_name
  force_destroy = var.s3_force_destroy
  tags = {
    Name       = local.base_s3_bucket_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

# tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "log" {
  count         = var.enable_s3_server_access_logging ? 1 : 0
  bucket        = local.log_s3_bucket_name
  force_destroy = var.s3_force_destroy
  tags = {
    Name       = local.log_s3_bucket_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_s3_bucket_logging" "base" {
  count         = length(aws_s3_bucket.log) > 0 ? 1 : 0
  bucket        = aws_s3_bucket.base.id
  target_bucket = aws_s3_bucket.log[count.index].id
  target_prefix = "${aws_s3_bucket.base.id}/"
}

resource "aws_s3_bucket_public_access_block" "base" {
  bucket                  = aws_s3_bucket.base.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "log" {
  count                   = length(aws_s3_bucket.log) > 0 ? 1 : 0
  bucket                  = aws_s3_bucket.log[count.index].id
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
      kms_master_key_id = var.s3_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  count  = length(aws_s3_bucket.log) > 0 ? 1 : 0
  bucket = aws_s3_bucket.log[count.index].id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_kms_key_arn
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

resource "aws_s3_bucket_versioning" "log" {
  count  = length(aws_s3_bucket.log) > 0 ? 1 : 0
  bucket = aws_s3_bucket.log[count.index].id
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
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = var.s3_abort_incomplete_multipart_upload_days
    }
    expiration {
      days = var.s3_expiration_days
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log" {
  count  = length(aws_s3_bucket.log) > 0 ? 1 : 0
  bucket = aws_s3_bucket.log[count.index].id
  rule {
    status = "Enabled"
    id     = "Move-to-Intelligent-Tiering-after-0day"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_expiration {
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = var.s3_abort_incomplete_multipart_upload_days
    }
    expiration {
      days = var.s3_expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "base" {
  bucket = aws_s3_bucket.base.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudTrailGetS3BucketAcl"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.base.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
          }
        }
      },
      {
        Sid    = "CloudTrailPutS3Objects"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.base.arn}/${var.cloudtrail_s3_key_prefix}/AWSLogs/${local.account_id}/*"]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
          }
        }
      },
      {
        Sid    = "ConfigGetS3BucketAclAndListS3Bucket"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = [aws_s3_bucket.base.arn]
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = local.account_id
          }
        }
      },
      {
        Sid    = "ConfigPutS3Buckets"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.base.arn}/${var.config_s3_key_prefix}/AWSLogs/${local.account_id}/Config/*"]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "AWS:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "log" {
  count  = length(aws_s3_bucket.log) > 0 ? 1 : 0
  bucket = aws_s3_bucket.log[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_s3_bucket.log[count.index].id}-policy"
    Statement = [
      {
        Sid    = "S3PutS3ServerAccessLogs"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.log[count.index].arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:s3:::${var.system_name}-${var.env_type}-*"
          }
        }
      }
    ]
  })
}

resource "aws_s3control_storage_lens_configuration" "s3" {
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
