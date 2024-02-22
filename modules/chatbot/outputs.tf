output "chatbot_slack_channel_configuration_id" {
  description = "Chatbot Slack channel configuration ID"
  value       = awscc_chatbot_slack_channel_configuration.slack.id
}

output "chatbot_iam_role_arn" {
  description = "Chatbot IAM role ARN"
  value       = aws_iam_role.slack.arn
}
