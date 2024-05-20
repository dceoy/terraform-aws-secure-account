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

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = null
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
  validation {
    condition     = var.iam_role_max_session_duration >= 3600 && var.iam_role_max_session_duration <= 43200
    error_message = "IAM role max session duration must be between 3600 and 43200"
  }
}

variable "iam_force_destroy" {
  description = "IAM force destroy"
  type        = bool
  default     = true
}

variable "enable_iam_accessanalyzer" {
  description = "Enable IAM Access Analyzer"
  type        = bool
  default     = true
}

variable "github_repositories_requiring_oidc" {
  description = "GitHub repositories requiring OIDC"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([
      for r in var.github_repositories_requiring_oidc : can(regexall("^[A-Za-z0-9_.-]+?/([A-Za-z0-9_.:/-]+[*]?|\\*)$", r))
    ])
    error_message = "GitHub repositories must be in the format 'organization/repository'"
  }
}

variable "github_iam_oidc_provider_iam_policy_arns" {
  description = "IAM role policy ARNs for the GitHub IAM OIDC provider"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  validation {
    condition = alltrue([
      for a in var.github_iam_oidc_provider_iam_policy_arns : can(regex("arn:aws:iam::(aws|[0-9]+):policy/[A-Za-z0-9_-]+", a))
    ])
    error_message = "IAM role policy ARNs must be valid ARNs"
  }
}

variable "github_enterprise_slug" {
  description = "GitHub Enterprise slug"
  type        = string
  default     = null
}
