output "iam_accessanalyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = module.iam.iam_accessanalyzer_id
}

output "ecr_registry_id" {
  description = "ECR registry ID"
  value       = module.ecr.ecr_registry_id
}

output "s3_storage_lens_configuration_id" {
  description = "S3 Storage Lens configuration ID"
  value       = module.s3.s3_storage_lens_configuration_id
}
