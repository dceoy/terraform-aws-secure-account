module "iam" {
  source                                   = "../../modules/iam"
  system_name                              = var.system_name
  env_type                                 = var.env_type
  account_alias                            = var.account_alias
  administrator_iam_user_names             = var.administrator_iam_user_names
  developer_iam_user_names                 = var.developer_iam_user_names
  readonly_iam_user_names                  = var.readonly_iam_user_names
  billing_iam_user_names                   = var.billing_iam_user_names
  account_iam_user_names                   = var.account_iam_user_names
  iam_role_max_session_duration            = var.iam_role_max_session_duration
  iam_role_force_detach_policies           = var.iam_role_force_detach_policies
  iam_user_force_destroy                   = var.iam_user_force_destroy
  iam_password_reuse_prevention            = var.iam_password_reuse_prevention
  iam_password_max_age                     = var.iam_password_max_age
  enable_iam_accessanalyzer                = var.enable_iam_accessanalyzer
  github_repositories_requiring_oidc       = var.github_repositories_requiring_oidc
  github_iam_oidc_provider_iam_policy_arns = var.github_iam_oidc_provider_iam_policy_arns
  github_enterprise_slug                   = var.github_enterprise_slug
}

module "kms" {
  source                          = "../../modules/kms"
  system_name                     = var.system_name
  env_type                        = var.env_type
  kms_key_deletion_window_in_days = var.kms_key_deletion_window_in_days
  kms_key_rotation_period_in_days = var.kms_key_rotation_period_in_days
}

module "s3" {
  source                                    = "../../modules/s3"
  system_name                               = var.system_name
  env_type                                  = var.env_type
  s3_kms_key_arn                            = module.kms.kms_key_arn
  s3_expiration_days                        = var.s3_expiration_days
  s3_force_destroy                          = var.s3_force_destroy
  s3_noncurrent_version_expiration_days     = var.s3_noncurrent_version_expiration_days
  s3_abort_incomplete_multipart_upload_days = var.s3_abort_incomplete_multipart_upload_days
  s3_expired_object_delete_marker           = var.s3_expired_object_delete_marker
  enable_s3_server_access_logging           = var.enable_s3_server_access_logging
  enable_s3_storage_lens                    = var.enable_s3_storage_lens
}

module "cloudtrail" {
  count          = var.enable_cloudtrail ? 1 : 0
  source         = "../../modules/cloudtrail"
  system_name    = var.system_name
  env_type       = var.env_type
  s3_bucket_id   = module.s3.awslogs_s3_bucket_id
  s3_kms_key_arn = module.kms.kms_key_arn
}

module "guardduty" {
  count                                               = var.enable_guardduty ? 1 : 0
  source                                              = "../../modules/guardduty"
  system_name                                         = var.system_name
  env_type                                            = var.env_type
  cloudformation_stackset_administration_iam_role_arn = module.iam.cloudformation_stackset_administration_iam_role_arn
  cloudformation_stackset_execution_iam_role_arn      = module.iam.cloudformation_stackset_execution_iam_role_arn
  guardduty_finding_publishing_frequency              = var.guardduty_finding_publishing_frequency
}

module "config" {
  count                                = var.enable_config ? 1 : 0
  source                               = "../../modules/config"
  system_name                          = var.system_name
  env_type                             = var.env_type
  iam_role_force_detach_policies       = var.iam_role_force_detach_policies
  s3_bucket_id                         = module.s3.awslogs_s3_bucket_id
  s3_kms_key_arn                       = module.kms.kms_key_arn
  allow_non_console_access_without_mfa = false
}

module "securityhub" {
  depends_on                              = [module.guardduty, module.config]
  count                                   = var.enable_securityhub ? 1 : 0
  source                                  = "../../modules/securityhub"
  system_name                             = var.system_name
  env_type                                = var.env_type
  sns_kms_key_arn                         = module.kms.kms_key_arn
  securityhub_subscribed_standards        = var.securityhub_subscribed_standards
  securityhub_subscribed_products         = var.securityhub_subscribed_products
  securityhub_disabled_standards_controls = var.securityhub_disabled_standards_controls
}

module "budgets" {
  count                      = var.enable_budgets ? 1 : 0
  source                     = "../../modules/budgets"
  system_name                = var.system_name
  env_type                   = var.env_type
  sns_kms_key_arn            = module.kms.kms_key_arn
  budget_time_unit           = var.budget_time_unit
  budget_limit_amount_in_usd = var.budget_limit_amount_in_usd
}

module "chatbot" {
  count = (
    var.chatbot_slack_workspace_id != null
    && var.chatbot_slack_channel_id != null
    && (var.enable_securityhub || var.enable_budgets)
  ) ? 1 : 0
  source                         = "../../modules/chatbot"
  system_name                    = var.system_name
  env_type                       = var.env_type
  iam_role_force_detach_policies = var.iam_role_force_detach_policies
  sns_topic_arns = compact([
    length(module.budgets) > 0 ? module.budgets[0].budgets_sns_topic_arn : null,
    length(module.securityhub) > 0 ? module.securityhub[0].securityhub_sns_topic_arn : null
  ])
  chatbot_slack_workspace_id    = var.chatbot_slack_workspace_id
  chatbot_slack_channel_id      = var.chatbot_slack_channel_id
  chatbot_guardrail_policy_arns = var.chatbot_guardrail_policy_arns
  chatbot_logging_level         = var.chatbot_logging_level
}

module "ecr" {
  source = "../../modules/ecr"
}
