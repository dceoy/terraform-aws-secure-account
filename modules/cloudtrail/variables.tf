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

variable "s3_bucket_id" {
  description = "S3 bucket ID"
  type        = string
  default     = null
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
