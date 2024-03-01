output "securityhub_id" {
  description = "Security Hub ID"
  value       = aws_securityhub_account.standard.id
}

output "securityhub_event_rule_id" {
  description = "Security Hub Event Rule ID"
  value       = aws_cloudwatch_event_rule.securityhub.id
}

output "securityhub_sns_topic_arn" {
  description = "Security Hub SNS Topic ARN"
  value       = aws_sns_topic.securityhub.arn
}
