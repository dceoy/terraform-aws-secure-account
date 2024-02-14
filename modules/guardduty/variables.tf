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

variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = null
}

variable "finding_publishing_frequency" {
  description = "Finding publishing frequency"
  type        = string
  default     = "SIX_HOURS"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "Finding publishing frequency must be one of FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS"
  }
}

variable "cloudformation_stackset_administration_iam_role_arn" {
  description = "CloudFormation StackSet Administration IAM Role ARN"
  type        = string
  default     = null
}

variable "cloudformation_stackset_execution_iam_role_arn" {
  description = "CloudFormation StackSet Execution IAM Role ARN"
  type        = string
  default     = null
}
