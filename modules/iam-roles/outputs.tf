output "uploader_role_name" {
  value = aws_iam_role.uploader.name
}

output "viewer_role_name" {
  value = aws_iam_role.viewer.name
}

output "sysadmin_role_name" {
  value = aws_iam_role.sysadmin.name
}

output "security_admin_role_name" {
  value = aws_iam_role.security_admin.name
}

output "uploader_role_arn" {
  value = aws_iam_role.uploader.arn
}

output "viewer_role_arn" {
  value = aws_iam_role.viewer.arn
}
