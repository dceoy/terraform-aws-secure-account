output "s3_base_s3_bucket_id" {
  description = "S3 base S3 bucket ID"
  value       = aws_s3_bucket.base.id
}

output "s3_accesslog_s3_bucket_id" {
  description = "S3 accesslog S3 bucket ID"
  value       = aws_s3_bucket.accesslog.id
}

output "s3_kms_key_arn" {
  description = "S3 KMS key ARN"
  value       = aws_kms_key.common.arn
}

output "s3_kms_key_alias_name" {
  description = "S3 KMS key alias name"
  value       = aws_kms_alias.common.name
}

output "s3_storage_lens_configuration_id" {
  description = "S3 Storage Lens configuration ID"
  value       = length(aws_s3control_storage_lens_configuration.common) > 0 ? aws_s3control_storage_lens_configuration.common[0].id : null
}
