# tfsec:ignore:aws-iam-no-password-reuse
# tfsec:ignore:aws-iam-set-max-password-age
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8 # tfsec:ignore:aws-iam-set-minimum-password-length
  allow_users_to_change_password = true
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
}

resource "aws_accessanalyzer_analyzer" "account" {
  analyzer_name = "${var.system_name}-${var.env_type}-account-accessanalyzer"
  type          = "ACCOUNT"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-account-accessanalyzer"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
