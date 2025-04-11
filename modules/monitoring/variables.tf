variable "log_bucket_id" {
  description = "S3 bucket for CloudTrail logs"
  type        = string
}

variable "sns_email" {
  description = "Email address to subscribe to SNS notifications"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
}

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}