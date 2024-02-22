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

variable "enable_guardduty" {
  description = "Enable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable Config"
  type        = bool
  default     = true
}

variable "enable_budgets" {
  description = "Enable Budgets"
  type        = bool
  default     = true
}
