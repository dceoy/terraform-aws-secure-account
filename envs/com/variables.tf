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
  default     = "com"
}
