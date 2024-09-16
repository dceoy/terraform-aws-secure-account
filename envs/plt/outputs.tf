output "iam_accessanalyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = module.iam.iam_accessanalyzer_id
}

output "cloudformation_stackset_administration_iam_role_arn" {
  description = "CloudFormation StackSet administration IAM role ARN"
  value       = module.iam.cloudformation_stackset_administration_iam_role_arn
}

output "cloudformation_stackset_execution_iam_role_arn" {
  description = "CloudFormation StackSet execution IAM role ARN"
  value       = module.iam.cloudformation_stackset_execution_iam_role_arn
}

output "administrator_iam_role_arn" {
  description = "Administrator IAM role ARN"
  value       = module.iam.administrator_iam_role_arn
}

output "administrator_iam_policy_arn" {
  description = "Administrator IAM policy ARN"
  value       = module.iam.administrator_iam_policy_arn
}

output "developer_iam_policy_arn" {
  description = "Developer IAM policy ARN"
  value       = module.iam.developer_iam_policy_arn
}

output "user_mfa_iam_policy_arn" {
  description = "User MFA IAM policy ARN"
  value       = module.iam.user_mfa_iam_policy_arn
}

output "activate_iam_policy_arn" {
  description = "Activate IAM policy ARN"
  value       = module.iam.activate_iam_policy_arn
}

output "administrator_iam_group_arn" {
  description = "Administrator IAM group ARN"
  value       = module.iam.administrator_iam_group_arn
}

output "developer_iam_group_arn" {
  description = "Developer IAM group ARN"
  value       = module.iam.developer_iam_group_arn
}

output "readonly_iam_group_arn" {
  description = "Readonly IAM group ARN"
  value       = module.iam.readonly_iam_group_arn
}

output "activate_iam_group_arn" {
  description = "Activate IAM user names"
  value       = module.iam.activate_iam_group_arn
}

output "iam_user_ids" {
  description = "IAM user IDs"
  value       = module.iam.iam_user_ids
}

output "github_iam_oidc_provider_arn" {
  description = "GitHub IAM OIDC provider ARN"
  value       = module.iam.github_iam_oidc_provider_arn
}

output "github_iam_oidc_provider_iam_role_arns" {
  description = "GitHub IAM OIDC provider IAM role ARNs"
  value       = module.iam.github_iam_oidc_provider_iam_role_arns
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = module.kms.kms_key_arn
}

output "kms_key_alias_name" {
  description = "KMS key alias name"
  value       = module.kms.kms_key_alias_name
}

output "s3_base_s3_bucket_id" {
  description = "S3 base S3 bucket ID"
  value       = module.s3.s3_base_s3_bucket_id
}

output "s3_log_s3_bucket_id" {
  description = "S3 log S3 bucket ID"
  value       = module.s3.s3_log_s3_bucket_id
}

output "s3_storage_lens_configuration_id" {
  description = "S3 Storage Lens configuration ID"
  value       = module.s3.s3_storage_lens_configuration_id
}

output "cloudtrail_trail_id" {
  description = "CloudTrail trail ID"
  value       = length(module.cloudtrail) > 0 ? module.cloudtrail[0].cloudtrail_trail_id : null
}

output "guardduty_stack_set_id" {
  description = "GuardDuty StackSet ID"
  value       = length(module.guardduty) > 0 ? module.guardduty[0].guardduty_stack_set_id : null
}

output "guardduty_stack_set_instance_ids" {
  description = "GuardDuty StackSet Instance IDs"
  value       = length(module.guardduty) > 0 ? module.guardduty[0].guardduty_stack_set_instance_ids : null
}

output "config_configuration_recorder_id" {
  description = "Config configuration recorder ID"
  value       = length(module.config) > 0 ? module.config[0].config_configuration_recorder_id : null
}

output "config_delivery_channel_id" {
  description = "Config delivery channel ID"
  value       = length(module.config) > 0 ? module.config[0].config_delivery_channel_id : null
}

output "config_iam_role_arn" {
  description = "Config IAM role ARN"
  value       = length(module.config) > 0 ? module.config[0].config_iam_role_arn : null
}

output "config_root_mfa_rule_id" {
  description = "Config root MFA rule ID"
  value       = length(module.config) > 0 ? module.config[0].config_root_mfa_rule_id : null
}

output "config_user_mfa_rule_id" {
  description = "Config user MFA rule ID"
  value       = length(module.config) > 0 ? module.config[0].config_user_mfa_rule_id : null
}

output "securityhub_id" {
  description = "Security Hub ID"
  value       = length(module.securityhub) > 0 ? module.securityhub[0].securityhub_id : null
}

output "securityhub_event_rule_id" {
  description = "Security Hub Event Rule ID"
  value       = length(module.securityhub) > 0 ? module.securityhub[0].securityhub_event_rule_id : null
}

output "securityhub_sns_topic_arn" {
  description = "Security Hub SNS Topic ARN"
  value       = length(module.securityhub) > 0 ? module.securityhub[0].securityhub_sns_topic_arn : null
}

output "budgets_budget_id" {
  description = "Budgets budget ID"
  value       = length(module.budgets) > 0 ? module.budgets[0].budgets_budget_id : null
}

output "budgets_sns_topic_arn" {
  description = "Budgets SNS topic ARN"
  value       = length(module.budgets) > 0 ? module.budgets[0].budgets_sns_topic_arn : null
}

output "chatbot_slack_channel_configuration_arn" {
  description = "Chatbot Slack channel configuration ARN"
  value       = length(module.chatbot) > 0 ? module.chatbot[0].chatbot_slack_channel_configuration_arn : null
}

output "chatbot_iam_role_arn" {
  description = "Chatbot IAM role ARN"
  value       = length(module.chatbot) > 0 ? module.chatbot[0].chatbot_iam_role_arn : null
}

output "ecr_registry_id" {
  description = "ECR registry ID"
  value       = module.ecr.ecr_registry_id
}
