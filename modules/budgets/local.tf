data "aws_caller_identity" "current" {}

locals {
  account_id             = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
  budgets_sns_topic_name = "${var.system_name}-${var.env_type}-budgets-sns-topic"
}
