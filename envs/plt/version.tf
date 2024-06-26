terraform {
  required_version = ">= 1.7.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.4.0"
    }
  }
}
