data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    # Restricting access to the specific IAM role (Uploader, Viewer, Admins)
    principals {
      type        = "AWS"
      identifiers = [
        # Replace these with actual IAM Role ARNs that need KMS access
        aws_iam_role.uploader.arn,
        aws_iam_role.viewer.arn
      ]
    }

    
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.this.key_id}"
    ]
  }
}

# 
# data "aws_caller_identity" "current" {}

# data "aws_region" "current" {}
