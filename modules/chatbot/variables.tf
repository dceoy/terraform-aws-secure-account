variable "system_name" {
  description = "System name"
  type        = string
  default     = "acc"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "plt"
}

variable "sns_topic_arns" {
  description = "SNS topic ARNs"
  type        = list(string)
  default     = []
}

variable "chatbot_slack_workspace_id" {
  description = "Chatbot Slack workspace ID"
  type        = string
  default     = null
}

variable "chatbot_slack_channel_id" {
  description = "Chatbot Slack channel ID"
  type        = string
  default     = "awschatbot"
}
