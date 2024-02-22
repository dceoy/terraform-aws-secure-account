output "s3_base_s3_bucket_id" {
  description = "S3 base S3 bucket ID"
  value       = aws_s3_bucket.base.id
}

output "s3_accesslog_s3_bucket_id" {
  description = "S3 accesslog S3 bucket ID"
  value       = aws_s3_bucket.accesslog.id
}

output "s3_storage_lens_configuration_id" {
  description = "S3 Storage Lens configuration ID"
  value       = length(aws_s3control_storage_lens_configuration.common) > 0 ? aws_s3control_storage_lens_configuration.common[0].id : null
}
