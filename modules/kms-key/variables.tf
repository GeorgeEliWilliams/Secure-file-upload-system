variable "alias" {
  description = "The alias name for the KMS key (without 'alias/' prefix)"
  type        = string
}

variable "description" {
  description = "A description for the KMS key"
  type        = string
}

variable "uploader_role_arn" {
  description = "The ARN of the uploader IAM role"
  type        = string
}

variable "viewer_role_arn" {
  description = "ARN of the viewer IAM role"
  type        = string
}