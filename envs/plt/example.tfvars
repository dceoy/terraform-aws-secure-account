region                                 = "us-east-1"
system_name                            = "acc"
env_type                               = "plt"
account_alias                          = null
force_destroy                          = true
administrator_iam_user_names           = []
developer_iam_user_names               = []
readonly_iam_user_names                = []
iam_force_destroy                      = true
s3_expiration_days                     = null
s3_force_destroy                       = true
guardduty_finding_publishing_frequency = "SIX_HOURS"
securityhub_subscribed_standards = [
  "aws-foundational-security-best-practices/v/1.0.0",
  "cis-aws-foundations-benchmark/v/1.4.0"
]
securityhub_subscribed_products = [
  "aws/guardduty",
  "aws/inspector",
  "aws/macie"
]
securityhub_disabled_standards_controls = {
  "cis-aws-foundations-benchmark/v/1.4.0/1.14" = "Make access key rotation optional."
}
budget_time_unit                = "ANNUALLY"
budget_limit_amount_in_usd      = 1000
chatbot_slack_workspace_id      = null
chatbot_slack_channel_id        = "awschatbot"
enable_iam_accessanalyzer       = true
enable_s3_server_access_logging = true
enable_s3_storage_lens          = true
enable_cloudtrail               = true
enable_guardduty                = true
enable_config                   = true
enable_securityhub              = true
enable_budgets                  = true
