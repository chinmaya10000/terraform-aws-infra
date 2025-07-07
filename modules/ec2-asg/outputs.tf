output "launch_template_id" {
  value = aws_launch_template.web.id
}

output "asg_name" {
  value = aws_autoscaling_group.web.name
}

output "cpu_scaling_policy_name" {
  value = aws_autoscaling_policy.cpu_target_tracking.name
}
