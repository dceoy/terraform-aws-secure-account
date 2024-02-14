data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

locals {
  account_id = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
  region     = var.region != null ? var.region : data.aws_region.current.name
  partition  = var.partition != null ? var.partition : data.aws_partition.current.partition
}

locals {
  base_s3_bucket_name      = "${var.system_name}-${var.env_type}-base-${local.region}-${local.account_id}"
  accesslog_s3_bucket_name = "${var.system_name}-${var.env_type}-accesslog-${local.region}-${local.account_id}"
}
