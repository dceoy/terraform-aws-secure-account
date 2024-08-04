output "chatbot_slack_channel_configuration_arn" {
  description = "Chatbot Slack channel configuration ARN"
  value       = aws_chatbot_slack_channel_configuration.slack.chat_configuration_arn
}

output "chatbot_iam_role_arn" {
  description = "Chatbot IAM role ARN"
  value       = aws_iam_role.slack.arn
}
