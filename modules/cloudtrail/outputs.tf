output "cloudtrail_trail_id" {
  description = "CloudTrail trail ID"
  value       = aws_cloudtrail.base.id
}

output "cloudtrail_kms_key_arn" {
  description = "CloudTrail KMS key ARN"
  value       = aws_kms_key.base.arn
}

output "cloudtrail_kms_key_alias_name" {
  description = "CloudTrail KMS key alias name"
  value       = aws_kms_alias.base.name
}
