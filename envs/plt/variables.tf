variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

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

variable "account_alias" {
  description = "AWS account alias"
  type        = string
  default     = null
}

variable "administrator_iam_user_names" {
  description = "Administrator IAM user names"
  type        = list(string)
  default     = []
}

variable "developer_iam_user_names" {
  description = "Developer IAM user names"
  type        = list(string)
  default     = []
}

variable "readonly_iam_user_names" {
  description = "Readonly IAM user names"
  type        = list(string)
  default     = []
}

variable "s3_expiration_days" {
  description = "S3 expiration days"
  type        = number
  default     = null
}

variable "guardduty_finding_publishing_frequency" {
  description = "GuardDuty finding publishing frequency"
  type        = string
  default     = "SIX_HOURS"
}

variable "budget_time_unit" {
  description = "Budget time unit"
  type        = string
  default     = "ANNUALLY"
}

variable "budget_limit_amount_in_usd" {
  description = "Budget limit amount in USD"
  type        = number
  default     = 1000
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

variable "enable_iam_accessanalyzer" {
  description = "Enable IAM Access Analyzer"
  type        = bool
  default     = true
}

variable "enable_s3_server_access_logging" {
  description = "Enable S3 server access logging"
  type        = bool
  default     = true
}

variable "enable_s3_storage_lens" {
  description = "Enable S3 Storage Lens"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable Config"
  type        = bool
  default     = true
}

variable "enable_securityhub" {
  description = "Enable Security Hub"
  type        = bool
  default     = true
}

variable "enable_budgets" {
  description = "Enable Budgets"
  type        = bool
  default     = true
}
