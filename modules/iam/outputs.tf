output "instance_profile_name" {
  description = "IAM Instance Profile name"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}
