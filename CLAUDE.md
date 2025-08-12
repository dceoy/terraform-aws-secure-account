# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains Terraform modules for implementing secure AWS account configurations. It provides a comprehensive security baseline following AWS best practices with integrated monitoring, access control, and compliance features.

## Core Architecture

### Module Structure
- **IAM Module**: Central access management with user types (administrator, developer, readonly, billing, account), OIDC provider for GitHub Actions
- **Security Modules**: GuardDuty (threat detection), Security Hub (centralized findings), Config (compliance monitoring), CloudTrail (API logging)
- **Infrastructure Modules**: KMS (encryption), S3 (secure storage), ECR (container registry)
- **Operational Modules**: Budgets (cost monitoring), Chatbot (Slack notifications)

### Environment Configuration
- Primary environment located in `envs/plt/` (plt = platform)
- Main orchestration in `envs/plt/main.tf` with conditional module deployments
- Configuration through `terraform.tfvars` and backend config in `aws.tfbackend`

## Essential Commands

### Initial Setup
```bash
# Create S3 bucket for Terraform state
aws cloudformation create-stack \
    --stack-name s3-for-terraform \
    --template-body file://cloudformation/s3-for-terraform.cfn.yml

# Initialize configuration files
cp envs/plt/example.tfbackend envs/plt/aws.tfbackend
cp envs/plt/example.tfvars envs/plt/terraform.tfvars

# Initialize Terraform
terraform -chdir='envs/plt/' init -upgrade -reconfigure -backend-config='./aws.tfbackend'
```

### Development Workflow
```bash
# Plan changes
terraform -chdir='envs/plt/' plan -var-file='./terraform.tfvars'

# Apply changes
terraform -chdir='envs/plt/' apply -var-file='./terraform.tfvars' -auto-approve

# Destroy infrastructure
terraform -chdir='envs/plt/' destroy -var-file='./terraform.tfvars' -auto-approve
```

### Linting and Validation
The project uses GitHub Actions for automated linting:
- CloudFormation templates are linted using `aws-cloudformation-lint`
- Terraform code is validated using `terraform-lint-and-scan`
- Run validation manually through GitHub Actions workflow dispatch

## Key Configuration Files

### `envs/plt/terraform.tfvars`
Contains all variable values including:
- AWS region and account configuration
- User lists for different access levels
- Feature flags for optional services
- Security settings and compliance standards
- Slack integration parameters

### `envs/plt/variables.tf`
Comprehensive variable definitions with validation rules for all configurable parameters

## Module Dependencies

Modules have specific dependencies that must be respected:
1. **KMS** → provides encryption keys for other services
2. **IAM** → provides roles and policies required by other modules
3. **S3** → provides logging buckets for CloudTrail and Config
4. **GuardDuty/Config** → must be enabled before Security Hub
5. **Security Hub/Budgets** → provide SNS topics for Chatbot notifications

## Security Considerations

- All modules implement least privilege access
- MFA enforcement is configured in IAM policies
- KMS encryption is used throughout with automatic key rotation
- GitHub OIDC is configured for secure CI/CD without long-lived credentials
- Security Hub aggregates findings from multiple AWS security services

## Current Environment Configuration

The `plt` environment is configured for:
- Region: us-east-1
- Account: clinical-dev
- Security services: All enabled (GuardDuty, Security Hub, Config, CloudTrail)
- Budget limit: `$5,000` annually
- Slack notifications: Configured for security and budget alerts

## Web Search Instructions

For tasks requiring web search, always use Gemini CLI (`gemini` command) instead of the built-in web search tools (WebFetch and WebSearch).
Gemini CLI is an AI workflow tool that provides reliable web search capabilities.

### Usage

```sh
# Basic search query
gemini --sandbox --prompt "WebSearch: <query>"

# Example: Search for latest news
gemini --sandbox --prompt "WebSearch: What are the latest developments in AI?"
```

### Policy

When users request information that requires web search:

1. Use `gemini --sandbox --prompt` command via terminal
2. Parse and present the Gemini response appropriately

This ensures consistent and reliable web search results through the Gemini API.
