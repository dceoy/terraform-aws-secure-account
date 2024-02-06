module "iam" {
  source      = "../../modules/iam"
  system_name = var.system_name
  env_type    = var.env_type
}

module "ecr" {
  source = "../../modules/ecr"
}
