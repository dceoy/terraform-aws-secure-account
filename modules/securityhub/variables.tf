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

variable "sns_kms_key_arn" {
  description = "SNS KMS key ARN"
  type        = string
  default     = null
}
