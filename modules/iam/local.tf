data "aws_caller_identity" "current" {}

locals {
  account_id = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
  iam_group_names = {
    for g in ["administrator", "developer", "readonly"] : g => "${var.system_name}-${var.env_type}-${g}-iam-group"
  }
}
