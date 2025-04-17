terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
  backend "s3" {
    encrypt = true
    # bucket         = ""
    # key            = ""
    # region         = "us-east-1"
    # use_lockfile   = true
  }
}
