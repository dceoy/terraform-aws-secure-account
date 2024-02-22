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

variable "region" {
  description = "AWS region"
  type        = string
  default     = null
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = null
}

variable "s3_kms_key_arn" {
  description = "S3 KMS key ARN"
  type        = string
  default     = null
}

variable "s3_expiration_days" {
  description = "S3 expiration days"
  type        = number
  default     = null
}

variable "enable_s3_storage_lens" {
  description = "Enable S3 Storage Lens"
  type        = bool
  default     = true
}

variable "cloudtrail_s3_key_prefix" {
  description = "CloudTrail S3 key prefix"
  type        = string
  default     = "cloudtrail"
}

variable "config_s3_key_prefix" {
  description = "Config S3 key prefix"
  type        = string
  default     = "config"
}
