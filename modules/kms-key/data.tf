data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "this" {
  statement {
    sid     = "AllowUploaderAndViewerUseOfKey"
    effect  = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    principals {
      type        = "AWS"
      identifiers = [
        var.uploader_role_arn,
        var.viewer_role_arn
      ]
    }

    resources = ["*"]
  }

  statement {
    sid     = "AllowAccountRootFullAccess"
    effect  = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*"
    ]

    resources = ["*"]
  }
}
