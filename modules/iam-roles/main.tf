resource "aws_iam_role" "uploader" {
  name = "s3-uploader-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "uploader_policy" {
  name   = "UploaderAccess"
  role   = aws_iam_role.uploader.name
  policy = data.aws_iam_policy_document.uploader_policy.json
}

resource "aws_iam_role" "viewer" {
  name = "s3-viewer-role"
  assume_role_policy = aws_iam_role.uploader.assume_role_policy
  tags = var.tags
}

resource "aws_iam_role_policy" "viewer_policy" {
  name   = "ViewerAccess"
  role   = aws_iam_role.viewer.name
  policy = data.aws_iam_policy_document.viewer_policy.json
}

resource "aws_iam_role" "sysadmin" {
  name = "s3-sysadmin-role"
  assume_role_policy = aws_iam_role.uploader.assume_role_policy
  tags = var.tags
}

resource "aws_iam_role_policy" "sysadmin_policy" {
  name   = "SysAdminAccess"
  role   = aws_iam_role.sysadmin.name
  policy = data.aws_iam_policy_document.admin_policy.json
}

resource "aws_iam_role" "security_admin" {
  name = "security-admin-role"
  assume_role_policy = aws_iam_role.uploader.assume_role_policy
  tags = var.tags
}

resource "aws_iam_role_policy" "security_policy" {
  name   = "SecurityAdminAccess"
  role   = aws_iam_role.security_admin.name
  policy = data.aws_iam_policy_document.security_policy.json
}
