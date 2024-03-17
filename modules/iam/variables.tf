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
