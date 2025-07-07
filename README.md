# Terraform Modular AWS Auto Scaling Web Infrastructure

This project provisions a fully auto-scalable web infrastructure on AWS using modular Terraform structure. It includes:

- VPC with public/private subnets
- Internet Gateway, NAT Gateway, routing
- Security groups for ALB and EC2
- Application Load Balancer (ALB)
- EC2 Auto Scaling Group with Launch Template
- IAM roles and instance profile
- CloudWatch alarm with SNS notification

## Prerequisites
- Terraform v1.3+
- AWS CLI configured
- A valid email for SNS alerts

## Structure
```
.
├── main.tf
├── local.tf
├── terraform.tfvars (optional)
├── modules
│   ├── vpc
│   ├── security-groups
│   ├── alb
│   ├── iam
│   ├── ec2-asg
│   └── cloudwatch-sns
└── user_data.sh
```

## Usage
```bash
terraform init
terraform plan
terraform apply
```

Make sure to confirm the SNS email subscription after applying.

## Clean Up
```bash
terraform destroy
```

## Maintainer
Chinmaya Pradhan – DevOps Engineer