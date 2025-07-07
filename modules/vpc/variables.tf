variable "vpc_cidr" {
  description = "value of VPC CIDR block"
  type        = string    
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Map of private subnets with CIDR and availability zone"
  type = map(object({
    cidr = string
    az   = string
  }))
}