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

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any IAM policies the IAM role has before destroying it"
  type        = bool
  default     = true
}

variable "iam_user_force_destroy" {
  description = "Whether to destroy the IAM user even if it has non-Terraform-managed IAM access keys, login profile or MFA devices"
  type        = bool
  default     = true
}

variable "github_repositories_requiring_oidc" {
  description = "GitHub repositories requiring OIDC"
  type        = list(string)
  default     = []
}

variable "github_iam_oidc_provider_iam_policy_arns" {
  description = "IAM role policy ARNs for the GitHub IAM OIDC provider"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

variable "github_enterprise_slug" {
  description = "GitHub Enterprise slug"
  type        = string
  default     = null
}

variable "s3_expiration_days" {
  description = "S3 expiration days"
  type        = number
  default     = null
}

variable "s3_force_destroy" {
  description = "Whether to delete all objects from the bucket when destroying the S3 bucket"
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
  description = "Whether to enable IAM Access Analyzer"
  type        = bool
  default     = true
}

variable "enable_s3_server_access_logging" {
  description = "Whether to enable S3 server access logging"
  type        = bool
  default     = true
}

variable "enable_s3_storage_lens" {
  description = "Whether to enable S3 Storage Lens"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Whether to enable CloudTrail"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Whether to enable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Whether to enable Config"
  type        = bool
  default     = true
}

variable "enable_securityhub" {
  description = "Whether to enable Security Hub"
  type        = bool
  default     = true
}

variable "enable_budgets" {
  description = "Whether to enable Budgets"
  type        = bool
  default     = true
}
