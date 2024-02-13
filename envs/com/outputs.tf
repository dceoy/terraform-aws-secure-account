output "iam_accessanalyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = module.iam.iam_accessanalyzer_id
}

output "cloudformation_stackset_administration_iam_role_arn" {
  description = "CloudFormation StackSet Administration IAM Role ARN"
  value       = module.iam.cloudformation_stackset_administration_iam_role_arn
}

output "cloudformation_stackset_execution_iam_role_arn" {
  description = "CloudFormation StackSet Execution IAM Role ARN"
  value       = module.iam.cloudformation_stackset_execution_iam_role_arn
}

output "ecr_registry_id" {
  description = "ECR registry ID"
  value       = module.ecr.ecr_registry_id
}

output "s3_storage_lens_configuration_id" {
  description = "S3 Storage Lens configuration ID"
  value       = module.s3.s3_storage_lens_configuration_id
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
