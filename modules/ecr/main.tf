resource "aws_ecr_registry_scanning_configuration" "scan" {
  scan_type = var.ecr_scan_type
}
