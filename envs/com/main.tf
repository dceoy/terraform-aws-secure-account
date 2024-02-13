module "iam" {
  source      = "../../modules/iam"
  system_name = var.system_name
  env_type    = var.env_type
  account_id  = local.account_id
}

module "ecr" {
  source = "../../modules/ecr"
}

module "s3" {
  source      = "../../modules/s3"
  system_name = var.system_name
  env_type    = var.env_type
  account_id  = local.account_id
}

module "budgets" {
  count                      = var.budget_limit_amount_in_usd != null ? 1 : 0
  source                     = "../../modules/budgets"
  system_name                = var.system_name
  env_type                   = var.env_type
  budget_time_unit           = var.budget_time_unit
  budget_limit_amount_in_usd = var.budget_limit_amount_in_usd
  account_id                 = local.account_id
}

module "guardduty" {
  source                                              = "../../modules/guardduty"
  system_name                                         = var.system_name
  env_type                                            = var.env_type
  account_id                                          = local.account_id
  cloudformation_stackset_administration_iam_role_arn = module.iam.cloudformation_stackset_administration_iam_role_arn
  cloudformation_stackset_execution_iam_role_arn      = module.iam.cloudformation_stackset_execution_iam_role_arn
}
