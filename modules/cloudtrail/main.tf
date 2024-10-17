# trivy:ignore:avd-aws-0162
resource "aws_cloudtrail" "trail" {
  name                          = "${var.system_name}-${var.env_type}-cloudtrail-trail"
  enable_logging                = true
  include_global_service_events = true
  s3_bucket_name                = var.s3_bucket_id
  s3_key_prefix                 = var.cloudtrail_s3_key_prefix
  kms_key_id                    = var.s3_kms_key_arn
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-cloudtrail-trail"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
