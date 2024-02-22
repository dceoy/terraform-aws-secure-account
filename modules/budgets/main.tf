resource "aws_budgets_budget" "cost" {
  name         = "${var.system_name}-${var.env_type}-budgets-budget"
  account_id   = local.account_id
  budget_type  = "COST"
  limit_amount = tostring(var.budget_limit_amount_in_usd)
  limit_unit   = "USD"
  time_unit    = var.budget_time_unit
  notification {
    notification_type         = "FORECASTED"
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    subscriber_sns_topic_arns = [aws_sns_topic.cost.arn]
  }
}

resource "aws_sns_topic" "cost" {
  name              = "${var.system_name}-${var.env_type}-budgets-sns-topic"
  display_name      = "${var.system_name}-${var.env_type}-budgets-sns-topic"
  kms_master_key_id = var.sns_kms_key_arn
  tags = {
    Name       = "${var.system_name}-${var.env_type}-budgets-sns-topic"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_sns_topic_policy" "cost" {
  arn = aws_sns_topic.cost.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_sns_topic.cost.name}-policy"
    Statement = [
      {
        Sid    = "BudgetsPublishSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "budgets.amazonaws.com"
        }
        Action   = ["sns:Publish"]
        Resource = [aws_sns_topic.cost.arn]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:budgets::${local.account_id}:*"
          }
        }
      }
    ]
  })
}
