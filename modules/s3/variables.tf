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

variable "partition" {
  description = "AWS partition"
  type        = string
  default     = null
}

variable "enable_s3_storage_lens" {
  description = "Enable S3 Storage Lens"
  type        = bool
  default     = true
}
