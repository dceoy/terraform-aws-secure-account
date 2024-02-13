output "iam_accessanalyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = aws_accessanalyzer_analyzer.account.id
}

output "cloudformation_stackset_administration_iam_role_arn" {
  description = "CloudFormation StackSet Administration IAM Role ARN"
  value       = aws_iam_role.cloudformation_stackset_administration.arn
}

output "cloudformation_stackset_execution_iam_role_arn" {
  description = "CloudFormation StackSet Execution IAM Role ARN"
  value       = aws_iam_role.cloudformation_stackset_execution.arn
}
