# 📘 Deployment Guide (AWS ECS / Terraform / GitHub Actions)
---
This guide explains how to deploy this application to AWS using:
- Terraform for infrastructure provisioning
- GitHub Actions for CI/CD automation
- AWS ECS (Fargate) for runtime execution
- ECR for container images

The setup is fully automated after bootstrap.

---

## 1. Prerequisites
---
You need:
- AWS account with permissions for:
	- ECS / ECR
	- IAM
	- S3
	- DynamoDB
	- ALB 
    - ACM 
- A domain managed via Cloudflare DNS, as DNS provisioning is automated through Terraform
- Docker installed (local testing only)
- Terraform installed locally (for bootstrap step)

---

## 2. Bootstrap (one-time setup)
---
Bootstrap provisions foundational AWS resources:
- S3 bucket (Terraform state)
- DynamoDB table (state locking)
- ECR repository
- IAM roles (including OIDC trust)

Run locally:
```bash
cd infra/bootstrap
terraform init
terraform plan
terraform apply
```

Output values:

After completion:
- oidc_role_arn
- state_bucket
- ecr_repo_url

-> Store these outputs securely for backend configuration.

---

## 4. Infrastructure Configuration (after bootstrap)
---
Required variables

```hcl
aws_region = "eu-west-1"

# Application
app_image = "<ACCOUNT_ID>.dkr.ecr.eu-west-1.amazonaws.com/app-repo:<IMAGE_TAG>"

app_port  = 8080
app_count = 2

health_path = ""/src/app/api/heartbeat""

# Domain
domain_name = "yourdomain.com"
subdomain   = "tm"

# Networking
vpc_cidr = "10.0.0.0/16"
az_count = 2

# DNS / TLS
acm_validation_method = "DNS"
```

### Important about app_image
✔ never use latest
✔ always use immutable tag (Git SHA)

---

## 4. GitHub Actions Required Settings
---
```yaml
permissions:
  id-token: write
  contents: read
```

### Required environment variables
- AWS_REGION 
- PROJECT_NAME
- REPO_NAME -> must equal ECR repo name used in bootstrap

### Required secrets
- OIDC_ROLE_ARN -> This is the role assumed via OIDC

---

## 5. CI/CD (Build & Push Image)
---
Workflow: Docker Build Pipeline

Triggered on:
- push to main
- changes in docker/

Steps:
- build image
- tag with git SHA
- push to ECR

---

## 6. Deployment Pipeline (Terraform Apply)
---
### Workflow: Infrastructure Deployment

### Steps:
- format check
- validation
- plan
- apply

### Security

Uses:
- OIDC authentication
- no AWS keys stored

---

## 8. Deployment Output
---
After successful apply:

Application becomes available at:
https://yourdomain.com

---

## 10. Common Issues
---
ECR not found

→ bootstrap not executed or region mismatch

⸻

S3 backend error

→ wrong region in backend config

⸻

Terraform state missing

→ bootstrap S3 bucket not created

---

## 11. Architecture Summary
---
```text
GitHub Actions
   ↓
Docker Build → ECR
   ↓
Terraform Apply
   ↓
ECS Fargate Deployment
   ↓
Public HTTPS Endpoint
```