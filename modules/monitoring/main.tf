# CloudTrail trail
resource "aws_cloudtrail" "this" {
  name                          = "secure-upload-trail"
  s3_bucket_name                = var.log_bucket_id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.cloudwatch_logs.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this.arn}:*"
  tags                          = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-ActivityTrail"
    }
  )
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/cloudtrail/secure-upload"
  retention_in_days = 30
  tags              = var.tags
}

# IAM Role for CloudTrail to push logs to CloudWatch
resource "aws_iam_role" "cloudwatch_logs" {
  name = "cloudtrail-to-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name   = "AllowCWLogs"
  role   = aws_iam_role.cloudwatch_logs.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:PutLogEvents", "logs:CreateLogStream"],
        Resource = "${aws_cloudwatch_log_group.this.arn}:*"
      }
    ]
  })
}

# SNS Topic for alerts
resource "aws_sns_topic" "this" {
  name = "security-alerts-topic"
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-Alerts-Topic"
    }
  )
}

# SNS Email Subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

# Event Rule for failed S3 access attempts (example)
resource "aws_cloudwatch_event_rule" "s3_unauthorized" {
  name        = "s3-unauthorized-access-rule"
  description = "Detect unauthorized S3 access"
  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["AWS API Call via CloudTrail"],
    "detail": {
      "eventSource": ["s3.amazonaws.com"],
      "errorCode": ["AccessDenied"]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.s3_unauthorized.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.this.arn
}
