resource "random_id" "suffix" {
  byte_length = 4
}


resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-${var.bucket_name}-${random_id.suffix.hex}"
    }
  )
}


resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "DeleteOldLogs"
    status = "Enabled"

    # Applying lifecycle rule to objects with prefix "logs/"
    prefix = "logs/"

    expiration {
      days = 90
    }
  }
}

