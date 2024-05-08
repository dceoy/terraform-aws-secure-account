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

variable "activate_iam_user_names" {
  description = "Activate IAM user names"
  type        = list(string)
  default     = []
}

variable "iam_role_max_session_duration" {
  description = "IAM role max session duration"
  type        = number
  default     = 43200
}

variable "iam_force_destroy" {
  description = "IAM force destroy"
  type        = bool
  default     = true
}

variable "s3_expiration_days" {
  description = "S3 expiration days"
  type        = number
  default     = null
}

variable "s3_force_destroy" {
  description = "S3 force destroy"
  type        = bool
  default     = true
}

variable "s3_noncurrent_version_expiration_days" {
  description = "S3 noncurrent version expiration days"
  type        = number
  default     = 7
}

variable "s3_abort_incomplete_multipart_upload_days" {
  description = "S3 abort incomplete multipart upload days"
  type        = number
  default     = 7
}

variable "guardduty_finding_publishing_frequency" {
  description = "GuardDuty finding publishing frequency"
  type        = string
  default     = "SIX_HOURS"
}

variable "securityhub_subscribed_standards" {
  description = "Security Hub subscribed standards"
  type        = list(string)
  default = [
    "aws-foundational-security-best-practices/v/1.0.0",
    "cis-aws-foundations-benchmark/v/1.4.0",
    "nist-800-53/v/5.0.0",
    "pci-dss/v/3.2.1"
  ]
}

variable "securityhub_subscribed_products" {
  description = "Security Hub subscribed products"
  type        = list(string)
  default = [
    "aws/guardduty",
    "aws/inspector",
    "aws/macie"
  ]
}

variable "securityhub_disabled_standards_controls" {
  description = "Security Hub disabled standards controls"
  type        = map(string)
  default = {
    "cis-aws-foundations-benchmark/v/1.4.0/1.14" = "Make access key rotation optional."
  }
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
