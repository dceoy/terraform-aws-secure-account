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

output "account_role_switch_iam_group_arn" {
  description = "Account role switch IAM group ARN"
  value       = module.iam.account_role_switch_iam_group_arn
}

output "readonly_iam_group_arn" {
  description = "Read-only IAM group ARN"
  value       = module.iam.readonly_iam_group_arn
}

output "account_role_switch_iam_policy_arn" {
  description = "Account role switch IAM policy ARN"
  value       = module.iam.account_role_switch_iam_policy_arn
}

output "user_mfa_iam_policy_arn" {
  description = "User MFA IAM policy ARN"
  value       = module.iam.user_mfa_iam_policy_arn
}

output "s3_base_s3_bucket_id" {
  description = "S3 base S3 bucket ID"
  value       = module.s3.s3_base_s3_bucket_id
}

output "s3_accesslog_s3_bucket_id" {
  description = "S3 accesslog S3 bucket ID"
  value       = module.s3.s3_accesslog_s3_bucket_id
}

output "s3_kms_key_arn" {
  description = "S3 KMS key ARN"
  value       = module.s3.s3_kms_key_arn
}

output "s3_kms_key_alias_name" {
  description = "S3 KMS key alias name"
  value       = module.s3.s3_kms_key_alias_name
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

output "available_regions" {
  description = "Available regions"
  value       = length(module.guardduty) > 0 ? module.guardduty[0].available_regions : null
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

output "budgets_budget_id" {
  description = "Budgets budget ID"
  value       = length(module.budgets) > 0 ? module.budgets[0].budgets_budget_id : null
}

output "budgets_sns_topic_id" {
  description = "Budgets SNS topic ID"
  value       = length(module.budgets) > 0 ? module.budgets[0].budgets_sns_topic_id : null
}

output "budgets_sns_topic_kms_key_arn" {
  description = "Budgets SNS topic KMS key ARN"
  value       = length(module.budgets) > 0 ? module.budgets[0].budgets_sns_topic_kms_key_arn : null
}

output "ecr_registry_id" {
  description = "ECR registry ID"
  value       = module.ecr.ecr_registry_id
}
