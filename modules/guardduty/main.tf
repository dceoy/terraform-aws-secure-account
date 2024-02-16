resource "aws_cloudformation_stack_set" "guardduty" {
  name                    = "${var.system_name}-${var.env_type}-guardduty-cloudformation-stackset"
  description             = "CloudFormation StackSet for GuardDuty"
  permission_model        = "SELF_MANAGED"
  administration_role_arn = local.cloudformation_stackset_administration_iam_role_arn
  execution_role_name     = local.cloudformation_stackset_execution_iam_role_name
  parameters = {
    SystemName                 = var.system_name
    EnvType                    = var.env_type
    FindingPublishingFrequency = var.finding_publishing_frequency
    SnsTopicArn                = aws_sns_topic.events.arn
  }
  template_body = file("${path.module}/guardduty-and-eventbridge.cfn.yml")
  operation_preferences {
    region_concurrency_type   = "PARALLEL"
    max_concurrent_percentage = 100
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-guardduty-cloudformation-stackset"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_cloudformation_stack_set_instance" "guardduty" {
  for_each       = local.available_regions
  account_id     = local.account_id
  region         = each.key
  stack_set_name = aws_cloudformation_stack_set.guardduty.name
  operation_preferences {
    region_concurrency_type   = "PARALLEL"
    max_concurrent_percentage = 100
  }
}

resource "aws_sns_topic" "events" {
  name              = local.guardduty_sns_topic_name
  display_name      = local.guardduty_sns_topic_name
  kms_master_key_id = aws_kms_key.events.arn
  tags = {
    Name       = local.guardduty_sns_topic_name
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_sns_topic_policy" "events" {
  arn = aws_sns_topic.events.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_sns_topic.events.name}-policy"
    Statement = [
      {
        Sid    = "EventsPublishSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = ["sns:Publish"]
        Resource = [aws_sns_topic.events.arn]
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
}

resource "aws_kms_key" "events" {
  description             = "KMS key for encrypting SNS messages for Events"
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
          Service = "events.amazonaws.com"
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
    Name       = "${local.guardduty_sns_topic_name}-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "events" {
  name          = "alias/${aws_kms_key.events.tags.Name}"
  target_key_id = aws_kms_key.events.arn
}
