output "guardduty_stack_set_id" {
  description = "GuardDuty StackSet ID"
  value       = aws_cloudformation_stack_set.guardduty.id
}

output "guardduty_stack_set_instance_ids" {
  description = "GuardDuty StackSet Instance IDs"
  value       = { for i in aws_cloudformation_stack_set_instance.guardduty : i.region => i.id }
}

output "guardduty_sns_topic_arn" {
  description = "GuardDuty SNS topic ARN"
  value       = aws_sns_topic.guardduty.arn
}
