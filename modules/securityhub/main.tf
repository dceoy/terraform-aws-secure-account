resource "aws_securityhub_account" "base" {
  enable_default_standards  = true
  control_finding_generator = "STANDARD_CONTROL"
  auto_enable_controls      = true
}
