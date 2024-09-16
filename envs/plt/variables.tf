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
  type        = map(list(string))
  default     = {}
  validation {
    condition = alltrue([
      for k, v in var.github_repositories_requiring_oidc : alltrue([
        for r in v : can(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+[*]?|\\*)$", r))
      ])
    ])
    error_message = "GitHub repositories must be in the format 'organization/repository'"
  }
}

variable "github_iam_oidc_provider_iam_policy_arns" {
  description = "IAM role policy ARNs for the GitHub IAM OIDC provider"
  type        = map(list(string))
  default     = {}
  validation {
    condition = alltrue([
      for k, v in var.github_iam_oidc_provider_iam_policy_arns : alltrue([
        for a in v : can(regex("arn:aws:iam::(aws|[0-9]+):policy/[A-Za-z0-9_-]+", a))
      ])
    ])
    error_message = "IAM role policy ARNs must be valid ARNs"
  }
}

variable "github_enterprise_slug" {
  description = "GitHub Enterprise slug"
  type        = string
  default     = null
}

variable "kms_key_deletion_window_in_days" {
  description = "The duration in days after which the key is deleted after destruction of the resource"
  type        = number
  default     = 30
  validation {
    condition     = var.kms_key_deletion_window_in_days >= 7 && var.kms_key_deletion_window_in_days <= 30
    error_message = "The deletion window must be between 7 and 30 days"
  }
}

variable "kms_key_rotation_period_in_days" {
  description = "The number of days after which AWS KMS rotates the key"
  type        = number
  default     = 365
  validation {
    condition     = var.kms_key_rotation_period_in_days >= 90 && var.kms_key_rotation_period_in_days <= 2560
    error_message = "The rotation period must be between 90 and 2560 days"
  }
}

variable "s3_expiration_days" {
  description = "Days to retain S3 objects"
  type        = number
  default     = null
}

variable "s3_force_destroy" {
  description = "Whether to delete all objects from the bucket when destroying the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_noncurrent_version_expiration_days" {
  description = "Days to retain the noncurrent versions of S3 objects"
  type        = number
  default     = 7
  validation {
    condition     = var.s3_noncurrent_version_expiration_days >= 1
    error_message = "s3_noncurrent_version_expiration_days must be greater than or equal to 1"
  }
}

variable "s3_abort_incomplete_multipart_upload_days" {
  description = "Days to retain incomplete multipart uploads in S3"
  type        = number
  default     = 7
  validation {
    condition     = var.s3_abort_incomplete_multipart_upload_days >= 1
    error_message = "s3_abort_incomplete_multipart_upload_days must be greater than or equal to 1"
  }
}

variable "s3_expired_object_delete_marker" {
  description = "Whether to delete expired S3 object delete markers"
  type        = bool
  default     = true
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
