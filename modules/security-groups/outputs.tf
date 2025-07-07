output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  description = "Web Security Group ID"
  value       = aws_security_group.web.id
}
