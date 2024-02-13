output "budgets_budget_id" {
  description = "Budgets budget ID"
  value       = aws_budgets_budget.cost.id
}

output "budgets_sns_topic_id" {
  description = "Budgets SNS topic ID"
  value       = aws_sns_topic.cost.id
}

output "budgets_sns_topic_kms_key_arn" {
  description = "Budgets SNS topic KMS key ARN"
  value       = aws_kms_key.cost.arn
}
