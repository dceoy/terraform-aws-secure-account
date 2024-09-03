terraform {
  required_version = ">= 1.7.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
}
