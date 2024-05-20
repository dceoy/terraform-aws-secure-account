data "aws_caller_identity" "current" {}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

locals {
  account_id                       = var.account_id != null ? var.account_id : data.aws_caller_identity.current.account_id
  tls_certificate_sha1_fingerprint = data.tls_certificate.github.certificates[0].sha1_fingerprint
}
