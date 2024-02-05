variable "ecr_scan_type" {
  description = "The scanning type to set for the registry"
  type        = string
  default     = "BASIC"
  validation {
    condition     = contains(["BASIC", "ENHANCED"], var.ecr_scan_type)
    error_message = "The scanning type must be either BASIC or ENHANCED"
  }
}
