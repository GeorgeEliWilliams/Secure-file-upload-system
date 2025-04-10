variable "bucket_name" {
  description = "Name of the logging S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the logging bucket"
  type        = map(string)
}
