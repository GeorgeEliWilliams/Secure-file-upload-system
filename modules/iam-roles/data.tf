# Uploader Policy
data "aws_iam_policy_document" "uploader_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = ["${var.upload_bucket_arn}/*"]
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = [var.upload_bucket_arn]
  }

  statement {
    actions   = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = [var.kms_key_arn]
  }
}

# Viewer Policy
data "aws_iam_policy_document" "viewer_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${var.upload_bucket_arn}/*"]
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = [var.upload_bucket_arn]
  }
}

# System Admin Policy
data "aws_iam_policy_document" "admin_policy" {
  statement {
    actions = ["s3:*"]
    resources = [
      var.upload_bucket_arn,
      "${var.upload_bucket_arn}/*"
    ]
  }

  statement {
    actions = ["kms:*"]
    resources = [var.kms_key_arn]
  }
}

# Security Admin Policy
data "aws_iam_policy_document" "security_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetBucketLogging",
      "cloudtrail:LookupEvents",
      "kms:DescribeKey",
      "kms:ListKeys",
      "kms:GetKeyPolicy"
    ]
    resources = ["*"]
  }
}
