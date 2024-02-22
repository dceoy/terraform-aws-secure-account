resource "aws_cloudformation_stack_set" "guardduty" {
  name                    = "${var.system_name}-${var.env_type}-guardduty-cloudformation-stackset"
  description             = "CloudFormation StackSet for GuardDuty"
  permission_model        = "SELF_MANAGED"
  administration_role_arn = local.cloudformation_stackset_administration_iam_role_arn
  execution_role_name     = local.cloudformation_stackset_execution_iam_role_name
  parameters = {
    SystemName                 = var.system_name
    EnvType                    = var.env_type
    FindingPublishingFrequency = var.guardduty_finding_publishing_frequency
    SnsTopicArn                = aws_sns_topic.guardduty.arn
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

resource "aws_sns_topic" "guardduty" {
  name              = "${var.system_name}-${var.env_type}-guardduty-sns-topic"
  display_name      = "${var.system_name}-${var.env_type}-guardduty-sns-topic"
  kms_master_key_id = var.sns_kms_key_arn
  tags = {
    Name       = "${var.system_name}-${var.env_type}-guardduty-sns-topic"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_sns_topic_policy" "guardduty" {
  arn = aws_sns_topic.guardduty.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_sns_topic.guardduty.name}-policy"
    Statement = [
      {
        Sid    = "EventsPublishSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = ["sns:Publish"]
        Resource = [aws_sns_topic.guardduty.arn]
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
