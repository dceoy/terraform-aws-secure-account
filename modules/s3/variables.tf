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
