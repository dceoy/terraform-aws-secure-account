output "iam_accessanalyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = length(aws_accessanalyzer_analyzer.account) > 0 ? aws_accessanalyzer_analyzer.account[0].id : null
}

output "cloudformation_stackset_administration_iam_role_arn" {
  description = "CloudFormation StackSet administration IAM role ARN"
  value       = aws_iam_role.cloudformation_stackset_administration.arn
}

output "cloudformation_stackset_execution_iam_role_arn" {
  description = "CloudFormation StackSet execution IAM role ARN"
  value       = aws_iam_role.cloudformation_stackset_execution.arn
}

output "administrator_iam_role_arn" {
  description = "Administrator IAM role ARN"
  value       = aws_iam_role.administrator.arn
}

output "account_role_switch_iam_group_arn" {
  description = "Account role switch IAM group ARN"
  value       = aws_iam_group.administrator.arn
}

output "readonly_iam_group_arn" {
  description = "Read-only IAM group ARN"
  value       = aws_iam_group.readonly.arn
}

output "account_role_switch_iam_policy_arn" {
  description = "Account role switch IAM policy ARN"
  value       = aws_iam_policy.switch.arn
}

output "user_mfa_iam_policy_arn" {
  description = "User MFA IAM policy ARN"
  value       = aws_iam_policy.mfa.arn
}

output "iam_user_ids" {
  description = "IAM user IDs"
  value       = [for u in aws_iam_user.developer : u.id]
}
