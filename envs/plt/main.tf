module "s3" {
  source                 = "../../modules/s3"
  system_name            = var.system_name
  env_type               = var.env_type
  account_id             = local.account_id
  enable_s3_storage_lens = var.enable_s3_storage_lens
}

module "cloudtrail" {
  count        = var.enable_cloudtrail ? 1 : 0
  source       = "../../modules/cloudtrail"
  system_name  = var.system_name
  env_type     = var.env_type
  s3_bucket_id = module.s3.s3_base_s3_bucket_id
  region       = var.region
  account_id   = local.account_id
}

module "iam" {
  source                    = "../../modules/iam"
  system_name               = var.system_name
  env_type                  = var.env_type
  account_id                = local.account_id
  enable_iam_accessanalyzer = var.enable_iam_accessanalyzer
}

module "ecr" {
  source = "../../modules/ecr"
}

module "budgets" {
  count                      = var.enable_budgets ? 1 : 0
  source                     = "../../modules/budgets"
  system_name                = var.system_name
  env_type                   = var.env_type
  budget_time_unit           = var.budget_time_unit
  budget_limit_amount_in_usd = var.budget_limit_amount_in_usd
  account_id                 = local.account_id
}

module "guardduty" {
  count                                               = var.enable_guardduty ? 1 : 0
  source                                              = "../../modules/guardduty"
  system_name                                         = var.system_name
  env_type                                            = var.env_type
  account_id                                          = local.account_id
  cloudformation_stackset_administration_iam_role_arn = module.iam.cloudformation_stackset_administration_iam_role_arn
  cloudformation_stackset_execution_iam_role_arn      = module.iam.cloudformation_stackset_execution_iam_role_arn
}
