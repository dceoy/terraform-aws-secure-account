output "awslogs_s3_bucket_id" {
  description = "AWS service logs S3 bucket ID"
  value       = aws_s3_bucket.awslogs.id
}

output "s3logs_s3_bucket_id" {
  description = "S3 server access logs S3 bucket ID"
  value       = length(aws_s3_bucket.s3logs) > 0 ? aws_s3_bucket.s3logs[0].id : null
}

output "s3_storage_lens_configuration_id" {
  description = "S3 Storage Lens configuration ID"
  value       = length(aws_s3control_storage_lens_configuration.s3) > 0 ? aws_s3control_storage_lens_configuration.s3[0].id : null
}
