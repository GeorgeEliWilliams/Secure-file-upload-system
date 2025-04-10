variable "bucket_name" {
  description = "Name of the main S3 upload bucket"
  type        = string
}

variable "logging_bucket" {
  description = "Name of the bucket to store access logs"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for server-side encryption"
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

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}