variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group will be created"
  type        = string
}

variable "web_tg_name" {
  description = "Name for the web target group"
  type        = string
}