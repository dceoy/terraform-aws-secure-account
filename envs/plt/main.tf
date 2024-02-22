module "iam" {
  source                       = "../../modules/iam"
  system_name                  = var.system_name
  env_type                     = var.env_type
  account_id                   = local.account_id
  account_alias                = var.account_alias
  administrator_iam_user_names = var.administrator_iam_user_names
  developer_iam_user_names     = var.developer_iam_user_names
  readonly_iam_user_names      = var.readonly_iam_user_names
  enable_iam_accessanalyzer    = var.enable_iam_accessanalyzer
}

module "kms" {
  source           = "../../modules/kms"
  system_name      = var.system_name
  env_type         = var.env_type
  account_id       = local.account_id
  region           = var.region
  enable_guardduty = var.enable_guardduty
  enable_config    = var.enable_config
  enable_budgets   = var.enable_budgets
}

module "s3" {
  source                          = "../../modules/s3"
  system_name                     = var.system_name
  env_type                        = var.env_type
  account_id                      = local.account_id
  region                          = var.region
  s3_kms_key_arn                  = module.kms.s3_kms_key_arn
  s3_expiration_days              = var.s3_expiration_days
  enable_s3_server_access_logging = var.enable_s3_server_access_logging
  enable_s3_storage_lens          = var.enable_s3_storage_lens
}

module "cloudtrail" {
  count          = var.enable_cloudtrail ? 1 : 0
  source         = "../../modules/cloudtrail"
  system_name    = var.system_name
  env_type       = var.env_type
  s3_bucket_id   = module.s3.s3_base_s3_bucket_id
  s3_kms_key_arn = module.kms.s3_kms_key_arn
}

module "guardduty" {
  count                                               = var.enable_guardduty ? 1 : 0
  source                                              = "../../modules/guardduty"
  system_name                                         = var.system_name
  env_type                                            = var.env_type
  account_id                                          = local.account_id
  cloudformation_stackset_administration_iam_role_arn = module.iam.cloudformation_stackset_administration_iam_role_arn
  cloudformation_stackset_execution_iam_role_arn      = module.iam.cloudformation_stackset_execution_iam_role_arn
  sns_kms_key_arn                                     = module.kms.sns_kms_key_arn
  guardduty_finding_publishing_frequency              = var.guardduty_finding_publishing_frequency
}

module "config" {
  count                                = var.enable_config ? 1 : 0
  source                               = "../../modules/config"
  system_name                          = var.system_name
  env_type                             = var.env_type
  account_id                           = local.account_id
  s3_bucket_id                         = module.s3.s3_base_s3_bucket_id
  s3_kms_key_arn                       = module.kms.s3_kms_key_arn
  sns_kms_key_arn                      = module.kms.sns_kms_key_arn
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
  account_id                 = local.account_id
  budget_time_unit           = var.budget_time_unit
  budget_limit_amount_in_usd = var.budget_limit_amount_in_usd
}

module "chatbot" {
  count = (
    var.chatbot_slack_workspace_id != null
    && var.chatbot_slack_channel_id != null
    && (var.enable_guardduty || var.enable_config || var.enable_budgets)
  ) ? 1 : 0
  source      = "../../modules/chatbot"
  system_name = var.system_name
  env_type    = var.env_type
  sns_topic_arns = compact([
    length(module.guardduty) > 0 ? module.guardduty[0].guardduty_sns_topic_arn : null,
    length(module.config) > 0 ? module.config[0].config_sns_topic_arn : null,
    length(module.budgets) > 0 ? module.budgets[0].budgets_sns_topic_arn : null
  ])
  chatbot_slack_workspace_id = var.chatbot_slack_workspace_id
  chatbot_slack_channel_id   = var.chatbot_slack_channel_id
}

module "ecr" {
  source = "../../modules/ecr"
}
