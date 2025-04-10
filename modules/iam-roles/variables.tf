variable "upload_bucket_arn" {
  description = "ARN of the upload S3 bucket"
  type        = string
}

variable "upload_bucket_name" {
  description = "Name of the upload S3 bucket"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS Key ARN used for encryption"
  type        = string
}

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
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
