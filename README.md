# 🚀 Secure Static Website Hosting on AWS (S3 + CloudFront + Terraform)

This project uses **Terraform** to deploy a secure, fast, and fully automated static website on AWS using:

- 🪣 **Amazon S3** (for file storage)
- 🌍 **CloudFront** (for global delivery and HTTPS)
- 🛠️ **Terraform** (for infrastructure as code)

🔐 **This solution follows AWS security best practices**:
- No public access to your S3 bucket
- Only CloudFront can read from S3
- HTTPS is enabled by default
- No manual steps after setup

---

## ✅ What This Project Does

- Creates a **private S3 bucket** (no public access)
- Uploads your static files (`index.html`, `error.html`)
- Provisions a **CloudFront CDN** in front of your S3 bucket
- Enables **TLS/SSL** for secure access (via HTTPS)
- Sets up **cache invalidation** when files are updated
- Uses **Terraform** to automate everything

---

---

## 💻 Prerequisites

Before running this project, you need:

- ✅ [Terraform installed](https://developer.hashicorp.com/terraform/downloads)
- ✅ [AWS CLI installed and configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- ✅ Basic knowledge of the terminal/command line
- ✅ AWS account with permissions to use S3, CloudFront, and IAM

---