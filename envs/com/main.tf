module "iam" {
  source      = "../../modules/iam"
  system_name = var.system_name
  env_type    = var.env_type
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
