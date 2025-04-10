output "kms_key_id" {
  description = "The KMS key ID"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "The KMS key ARN"
  value       = aws_kms_key.this.arn
}

output "kms_key_alias" {
  description = "The KMS key alias"
  value       = aws_kms_alias.this.name
}
