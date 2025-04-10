output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The ID of the upload bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the upload bucket"
}
