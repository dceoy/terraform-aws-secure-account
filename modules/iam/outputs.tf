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

output "administrator_iam_policy_arn" {
  description = "Administrator IAM policy ARN"
  value       = aws_iam_policy.administrator.arn
}

output "developer_iam_policy_arn" {
  description = "Developer IAM policy ARN"
  value       = aws_iam_policy.developer.arn
}

output "user_mfa_iam_policy_arn" {
  description = "User MFA IAM policy ARN"
  value       = aws_iam_policy.mfa.arn
}

output "activate_iam_policy_arn" {
  description = "Activate IAM policy ARN"
  value       = aws_iam_policy.activate.arn
}

output "administrator_iam_group_arn" {
  description = "Administrator IAM group ARN"
  value       = aws_iam_group.administrator.arn
}

output "developer_iam_group_arn" {
  description = "Developer IAM group ARN"
  value       = aws_iam_group.developer.arn
}

output "readonly_iam_group_arn" {
  description = "Readonly IAM group ARN"
  value       = aws_iam_group.readonly.arn
}

output "activate_iam_group_arn" {
  description = "Activate IAM group ARN"
  value       = aws_iam_group.activate.arn
}

output "iam_user_ids" {
  description = "IAM user IDs"
  value       = values(aws_iam_user.users)[*].id
}

output "github_iam_oidc_provider_arn" {
  description = "GitHub IAM OIDC provider ARN"
  value       = length(aws_iam_openid_connect_provider.github) > 0 ? aws_iam_openid_connect_provider.github[0].arn : null
}

output "github_iam_oidc_provider_iam_role_arn" {
  description = "GitHub IAM OIDC provider IAM role ARN"
  value       = length(aws_iam_role.github) > 0 ? aws_iam_role.github[0].arn : null
}
