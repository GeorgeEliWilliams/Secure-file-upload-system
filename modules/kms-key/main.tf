resource "aws_kms_key" "this" {
  description             = var.description
  enable_key_rotation     = true
  deletion_window_in_days = 10
  is_enabled              = true
}


resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.key_id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
}
