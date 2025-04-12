variable "project" {
  description = "Project name"
  type        = string
  default     = "multipart-uploader"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "eu-west-1"
}

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
  default = {
    CreatedBy = "George"
  }
}

variable "alias" {
  description = "List of aliases to create for the KMS key."
  type        = list(string)
  default     = ["secure-uploader-key"]
}

variable "description" {
  description = "A description for the KMS key"
  type        = string
  default = "kms key to be used by s3 bucket"
}

