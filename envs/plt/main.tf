module "iam" {
  source                    = "../../modules/iam"
  system_name               = var.system_name
  env_type                  = var.env_type
  account_id                = local.account_id
  account_alias             = var.account_alias
  iam_user_names            = var.iam_user_names
  enable_iam_accessanalyzer = var.enable_iam_accessanalyzer
}

module "s3" {
  source                 = "../../modules/s3"
  system_name            = var.system_name
  env_type               = var.env_type
  account_id             = local.account_id
  s3_expiration_days     = var.s3_expiration_days
  enable_s3_storage_lens = var.enable_s3_storage_lens
}

module "cloudtrail" {
  count          = var.enable_cloudtrail ? 1 : 0
  source         = "../../modules/cloudtrail"
  system_name    = var.system_name
  env_type       = var.env_type
  s3_bucket_id   = module.s3.s3_base_s3_bucket_id
  s3_kms_key_arn = module.s3.s3_kms_key_arn
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

module "config" {
  count                                = var.enable_config ? 1 : 0
  source                               = "../../modules/config"
  system_name                          = var.system_name
  env_type                             = var.env_type
  s3_bucket_id                         = module.s3.s3_base_s3_bucket_id
  s3_kms_key_arn                       = module.s3.s3_kms_key_arn
  account_id                           = local.account_id
  allow_non_console_access_without_mfa = false
}

module "securityhub" {
  count  = var.enable_securityhub ? 1 : 0
  source = "../../modules/securityhub"
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

module "ecr" {
  source = "../../modules/ecr"
}
