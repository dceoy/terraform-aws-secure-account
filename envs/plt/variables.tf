variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

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

variable "budget_time_unit" {
  description = "Budget time unit"
  type        = string
  default     = "ANNUALLY"
}

variable "budget_limit_amount_in_usd" {
  description = "Budget limit amount in USD"
  type        = number
  default     = null
}
