data "aws_caller_identity" "current" {}

data "aws_regions" "available" {
  all_regions = true
}

locals {
  account_id        = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
  available_regions = data.aws_regions.available.names
}

locals {
  cloudformation_stackset_administration_iam_role_arn = var.cloudformation_stackset_administration_iam_role_arn != null ? var.cloudformation_stackset_administration_iam_role_arn : "arn:aws:iam::${local.account_id}:role/AWSCloudFormationStackSetAdministrationRole"
  cloudformation_stackset_execution_iam_role_name     = var.cloudformation_stackset_execution_iam_role_arn != null ? element(split("/", var.cloudformation_stackset_execution_iam_role_arn), 1) : "AWSCloudFormationStackSetExecutionRole"
}
