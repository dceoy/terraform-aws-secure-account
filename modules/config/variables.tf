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

variable "s3_bucket_id" {
  description = "S3 bucket ID"
  type        = string
  default     = null
}

variable "s3_kms_key_arn" {
  description = "S3 KMS key ARN"
  type        = string
  default     = null
}

variable "allow_non_console_access_without_mfa" {
  description = "Allow non-console access without MFA"
  type        = bool
  default     = false
}

variable "config_s3_key_prefix" {
  description = "Config S3 key prefix"
  type        = string
  default     = "config"
}
