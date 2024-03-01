resource "aws_securityhub_account" "standard" {
  enable_default_standards  = true
  control_finding_generator = "STANDARD_CONTROL"
  auto_enable_controls      = true
}

resource "aws_securityhub_finding_aggregator" "standard" {
  depends_on   = [aws_securityhub_account.standard]
  linking_mode = "ALL_REGIONS"
}

resource "aws_iam_service_linked_role" "standard" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_securityhub_standards_subscription" "standard" {
  depends_on    = [aws_securityhub_account.standard]
  for_each      = local.securityhub_standard_arns
  standards_arn = each.value
}

resource "aws_cloudwatch_event_rule" "securityhub" {
  name           = "${var.system_name}-${var.env_type}-securityhub-sns-event-rule"
  description    = "Rule for Security Hub findings"
  state          = "ENABLED"
  event_bus_name = "default"
  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail_type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        ProductName = ["GuardDuty"]
        Workflow = {
          Status = ["NEW"]
        }
        RecordState = ["ACTIVE"]
      }
    }
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-securityhub-sns-event-rule"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_cloudwatch_event_target" "securityhub" {
  rule           = aws_cloudwatch_event_rule.securityhub.name
  event_bus_name = "default"
  target_id      = aws_sns_topic.securityhub.name
  arn            = aws_sns_topic.securityhub.arn
}

resource "aws_sns_topic" "securityhub" {
  name              = "${var.system_name}-${var.env_type}-securityhub-sns-topic"
  display_name      = "${var.system_name}-${var.env_type}-securityhub-sns-topic"
  kms_master_key_id = var.sns_kms_key_arn
  tags = {
    Name       = "${var.system_name}-${var.env_type}-securityhub-sns-topic"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_sns_topic_policy" "securityhub" {
  arn = aws_sns_topic.securityhub.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_sns_topic.securityhub.name}-policy"
    Statement = [
      {
        Sid    = "EventsPublishSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = ["sns:Publish"]
        Resource = [aws_sns_topic.securityhub.arn]
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
