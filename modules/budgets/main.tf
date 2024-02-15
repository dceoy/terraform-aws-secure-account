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
  name              = local.budgets_sns_topic_name
  display_name      = local.budgets_sns_topic_name
  kms_master_key_id = aws_kms_key.cost.arn
  tags = {
    Name       = local.budgets_sns_topic_name
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

resource "aws_kms_key" "cost" {
  description             = "KMS key for encrypting SNS messages for Budgets"
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
        Sid    = "BudgetsEncryptAndDecryptSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "budgets.amazonaws.com"
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
            "aws:SourceArn" = "arn:aws:budgets::${local.account_id}:*"
          }
        }
      }
    ]
  })
  tags = {
    Name       = "${local.budgets_sns_topic_name}-kms-key"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_kms_alias" "cost" {
  name          = "alias/${aws_kms_key.cost.tags.Name}"
  target_key_id = aws_kms_key.cost.arn
}
