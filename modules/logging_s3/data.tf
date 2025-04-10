data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowS3LoggingAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}
