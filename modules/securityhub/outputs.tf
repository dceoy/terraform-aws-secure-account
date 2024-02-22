output "securityhub_id" {
  description = "Security Hub ID"
  value       = aws_securityhub_account.standard.id
}
