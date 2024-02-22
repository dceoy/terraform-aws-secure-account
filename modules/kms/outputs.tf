output "s3_kms_key_arn" {
  description = "S3 KMS key ARN"
  value       = aws_kms_key.s3.arn
}

output "s3_kms_key_alias_name" {
  description = "S3 KMS key alias name"
  value       = aws_kms_alias.s3.name
}

output "sns_kms_key_arn" {
  description = "SNS KMS key ARN"
  value       = length(aws_kms_key.sns) > 0 ? aws_kms_key.sns[0].arn : null
}

output "sns_kms_key_alias_name" {
  description = "SNS KMS key alias name"
  value       = length(aws_kms_alias.sns) > 0 ? aws_kms_alias.sns[0].name : null
}
