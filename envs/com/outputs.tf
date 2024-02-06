output "iam_accessanalyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = module.iam.iam_accessanalyzer_id
}

output "ecr_registry_id" {
  description = "ECR registry ID"
  value       = module.ecr.ecr_registry_id
}
