variable "bucket_name" {
  description = "Name of the logging S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the logging bucket"
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