# Global
region        = "us-east-1"
system_name   = "acc"
env_type      = "plt"
account_alias = null

# AWS IAM
force_destroy                      = true
administrator_iam_user_names       = []
developer_iam_user_names           = []
readonly_iam_user_names            = []
activate_iam_user_names            = []
iam_role_max_session_duration      = 43200
iam_role_force_detach_policies     = true
iam_user_force_destroy             = true
enable_iam_accessanalyzer          = true
github_repositories_requiring_oidc = []
github_iam_oidc_provider_iam_policy_arns = [
  "arn:aws:iam::aws:policy/AdministratorAccess"
]
github_enterprise_slug = null

# Amazon S3
s3_expiration_days              = null
s3_force_destroy                = true
enable_s3_server_access_logging = true
enable_s3_storage_lens          = true

# AWS CloudTrail
enable_cloudtrail = true

# Amazon GuardDuty
enable_guardduty                       = true
guardduty_finding_publishing_frequency = "SIX_HOURS"

# AWS Config
enable_config = true

# AWS Security Hub
enable_securityhub = true
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

# AWS Budgets
enable_budgets             = true
budget_time_unit           = "ANNUALLY"
budget_limit_amount_in_usd = 1000

# AWS Chatbot
chatbot_slack_workspace_id = null
chatbot_slack_channel_id   = "awschatbot"
