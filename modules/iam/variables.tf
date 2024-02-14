variable "system_name" {
  description = "System name"
  type        = string
  default     = "adm"
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

variable "enable_iam_accessanalyzer" {
  description = "Enable IAM Access Analyzer"
  type        = bool
  default     = true
}
