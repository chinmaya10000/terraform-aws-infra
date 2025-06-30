# 🚀 Terraform AWS Auto-Scaling Web Infrastructure

This Terraform project builds a **production-ready, auto-scaling web application infrastructure on AWS**, complete with:

- ✅ VPC with public/private subnets across AZs
- ✅ Application Load Balancer (ALB)
- ✅ Auto Scaling Group (ASG) with Launch Templates
- ✅ CloudWatch alarms (CPU & Network-based)
- ✅ SNS alerts for scale events
- ✅ EC2 access via AWS SSM (no SSH/key required)

---

## 🔧 Technologies Used

- Terraform
- AWS EC2, ALB, ASG, VPC, SSM, CloudWatch, SNS
- Infrastructure as Code (IaC) best practices

---


---

## 📦 Features

### ✅ VPC
- Custom VPC with DNS support
- Public and private subnets across multiple Availability Zones
- NAT Gateway for internet access in private subnets

### ✅ ALB + Target Group
- Public ALB with listeners (HTTP + optional HTTPS)
- Health checks
- Listener rule forwarding to target group

### ✅ Auto Scaling Group
- Uses Launch Template
- Dynamic scale-in/scale-out via CloudWatch alarms
- Starts EC2 instances inside private subnets

### ✅ CloudWatch Monitoring & Scaling
- Alarms for:
  - High CPU utilization
  - Low CPU utilization
  - High/Low NetworkIn traffic
- Triggers ASG scaling policies
- Sends notifications via SNS (Email/SMS)

### ✅ SSM-Based EC2 Access
- No key pair required
- Secure access to instances via AWS SSM Session Manager

---

## 📥 Pre-Requisites

- AWS CLI & credentials configured
- Terraform v1.3+
- A registered domain (if planning to add HTTPS/ACM)
- (Optional) Route 53 hosted zone if using ACM with DNS validation

---

## 🚀 Deployment Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/chinmaya10000/terraform-aws-infra.git
   cd terraform-aws-infra
   git checkout feature/prod-infra-setup
   terraform init
   terraform apply
   


