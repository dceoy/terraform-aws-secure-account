output "config_configuration_recorder_id" {
  description = "Config Configuration Recorder ID"
  value       = aws_config_configuration_recorder.base.id
}

output "config_delivery_channel_id" {
  description = "Config Delivery Channel ID"
  value       = aws_config_delivery_channel.base.id
}

output "config_iam_role_arn" {
  description = "Config IAM Role ARN"
  value       = aws_iam_role.base.arn
}
