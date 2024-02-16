output "config_configuration_recorder_id" {
  description = "Config configuration recorder ID"
  value       = aws_config_configuration_recorder.main.id
}

output "config_delivery_channel_id" {
  description = "Config delivery channel ID"
  value       = aws_config_delivery_channel.main.id
}

output "config_iam_role_arn" {
  description = "Config IAM role ARN"
  value       = aws_iam_role.main.arn
}

output "config_root_mfa_rule_id" {
  description = "Config root MFA rule ID"
  value       = aws_config_config_rule.root_mfa.id
}

output "config_user_mfa_rule_id" {
  description = "Config user MFA rule ID"
  value       = aws_config_config_rule.user_mfa.id
}
