variable "system_name" {
  description = "System name"
  type        = string
  default     = "adm"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "com"
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = null
}
