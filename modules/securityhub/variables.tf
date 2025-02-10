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

variable "securityhub_subscribed_standards" {
  description = "Security Hub subscribed standards"
  type        = list(string)
  default = [
    "aws-foundational-security-best-practices/v/1.0.0",
    "cis-aws-foundations-benchmark/v/1.4.0",
    "nist-800-53/v/5.0.0",
    "pci-dss/v/3.2.1"
  ]
}

variable "securityhub_subscribed_products" {
  description = "Security Hub subscribed products"
  type        = list(string)
  default = [
    "aws/guardduty",
    "aws/inspector",
    "aws/macie"
  ]
}

variable "securityhub_disabled_standards_controls" {
  description = "Security Hub disabled standards controls"
  type        = map(string)
  default = {
    "cis-aws-foundations-benchmark/v/1.4.0/1.14" = "Make access key rotation optional."
  }
}
