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