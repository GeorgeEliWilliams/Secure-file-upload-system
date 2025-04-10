output "bucket_id" {
  description = "ID of the logging bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the logging bucket"
  value       = aws_s3_bucket.this.arn
}
