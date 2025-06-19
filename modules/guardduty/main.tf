resource "aws_cloudformation_stack_set" "guardduty" {
  name                    = "${var.system_name}-${var.env_type}-guardduty-cloudformation-stackset"
  description             = "CloudFormation StackSet for GuardDuty"
  permission_model        = "SELF_MANAGED"
  administration_role_arn = local.cloudformation_stackset_administration_iam_role_arn
  execution_role_name     = local.cloudformation_stackset_execution_iam_role_name
  parameters = {
    SystemName                 = var.system_name
    EnvType                    = var.env_type
    FindingPublishingFrequency = var.guardduty_finding_publishing_frequency
  }
  template_body = file("${path.module}/guardduty.cfn.yml")
  operation_preferences {
    region_concurrency_type   = "PARALLEL"
    max_concurrent_percentage = 100
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-guardduty-cloudformation-stackset"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_cloudformation_stack_set_instance" "guardduty" {
  for_each                  = local.available_regions
  account_id                = local.account_id
  stack_set_instance_region = each.key
  stack_set_name            = aws_cloudformation_stack_set.guardduty.name
  operation_preferences {
    region_concurrency_type   = "PARALLEL"
    max_concurrent_percentage = 100
  }
}
