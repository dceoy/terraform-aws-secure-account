data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

locals {
  securityhub_standard_arns = {
    aws_fsbp  = "arn:aws:securityhub:${local.region}::standards/aws-foundational-security-best-practices/v/1.0.0"
    cis120    = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
    cis140    = "arn:aws:securityhub:${local.region}::standards/cis-aws-foundations-benchmark/v/1.4.0"
    nist80053 = "arn:aws:securityhub:${local.region}::standards/nist-800-53/v/5.0.0"
    pci_dss   = "arn:aws:securityhub:${local.region}::standards/pci-dss/v/3.2.1"
  }
}
