variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "sns_kms_key_arn" {
  description = "SNS KMS key ARN"
  type        = string
  default     = null
}

variable "budget_time_unit" {
  description = "Budget time unit"
  type        = string
  default     = "ANNUALLY"
  validation {
    condition     = contains(["DAILY", "MONTHLY", "QUARTERLY", "ANNUALLY"], var.budget_time_unit)
    error_message = "Budget time unit must be one of DAILY, MONTHLY, QUARTERLY, or ANNUALLY"
  }
}

variable "budget_limit_amount_in_usd" {
  description = "Budget limit amount in USD"
  type        = number
  default     = 1000
}
