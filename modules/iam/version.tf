terraform {
  required_version = ">= 1.7.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 0.77.0"
    }
  }
}
