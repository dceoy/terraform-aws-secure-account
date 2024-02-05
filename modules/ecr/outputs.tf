output "ecr_registry_id" {
  description = "ECR registry ID"
  value       = aws_ecr_registry_scanning_configuration.scan.registry_id
}
