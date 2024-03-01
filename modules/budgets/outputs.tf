output "budgets_budget_id" {
  description = "Budgets budget ID"
  value       = aws_budgets_budget.cost.id
}

output "budgets_sns_topic_arn" {
  description = "Budgets SNS topic ARN"
  value       = aws_sns_topic.budgets.arn
}
