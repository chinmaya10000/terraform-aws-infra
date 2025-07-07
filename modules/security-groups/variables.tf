variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type = string
}

variable "web_ingress_cidr" {
  description = "CIDR block allowed to SSH into EC2"
  type = string
}