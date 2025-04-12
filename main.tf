# KMS Key for encryption
module "kms-key" {
  source            = "./modules/kms-key"
  alias             = var.alias
  description       = var.description
  uploader_role_arn = module.iam-roles.uploader_role_arn
  viewer_role_arn   = module.iam-roles.viewer_role_arn
}

# Logging Bucket
module "logging_s3" {
  source      = "./modules/logging_s3"
  bucket_name = "my-logging-bucket-007"
  tags        = var.tags
  project     = var.project
  environment = var.environment
}

module "iam-roles" {
  source             = "./modules/iam-roles"
  upload_bucket_arn  = module.upload-s3-bucket.bucket_arn
  upload_bucket_name = module.upload-s3-bucket.bucket_name
  kms_key_arn        = module.kms-key.kms_key_arn
  tags               = var.tags
  project            = var.project
  environment        = var.environment
  region             = var.region
}

# Upload Bucket (Secure Bucket)
module "upload-s3-bucket" {
  source         = "./modules/upload-s3-bucket"
  bucket_name    = "my-secure-upload-bucket-007"
  logging_bucket = module.logging_s3.bucket_id
  kms_key_arn    = module.kms-key.kms_key_arn
  project        = var.project
  environment    = var.environment
  tags           = var.tags
}

# Monitoring & Alerts (CloudTrail, CloudWatch, SNS)
module "monitoring" {
  source        = "./modules/monitoring"
  project       = var.project
  environment   = var.environment
  region        = var.region
  tags          = var.tags
  log_bucket_id = module.logging_s3.bucket_id
  sns_email     = "williamsgeorge950@gmail.com"
}