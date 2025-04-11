output "cloudtrail_arn" {
  value = aws_cloudtrail.this.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.this.name
}
