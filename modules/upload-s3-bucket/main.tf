resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = false
  tags = merge(
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


resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.this.id
  target_bucket = var.logging_bucket
  target_prefix = "s3-access-logs/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}
