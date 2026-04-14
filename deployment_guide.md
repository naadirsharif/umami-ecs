# 📘 Deployment Guide (AWS ECS / Terraform / GitHub Actions)

This guide explains how to deploy this application using:
- Terraform (infrastructure)
- GitHub Actions (CI/CD)
- Amazon ECS (Fargate runtime)
- Amazon ECR (Docker images)
- Cloudflare (DNS)

---

## 1. Prerequisites

You need:
- AWS account with permissions for: ECS / ECR, IAM, S3, DynamoDB, ALB, ACM 
- Domain managed via Cloudflare (DNS is automated via Terraform)
- Docker (optional for local testing)
- Terraform (for bootstrap only)

---

## 2. Bootstrap (one-time setup)

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

After running `terraform apply`, Terraform will prompt for required variables:
```bash
var.region
  AWS Region

  Enter a value: eu-central-1

var.github_repo
  GitHub repository in the format 'owner/repo' that is allowed to assume IAM role via GitHub Actions OIDC

  Enter a value: naadirsharif/umami-ecs
```

Outputs (save these!)
- state_bucket
- ecr_repo_url
- oidc_role_arn

---

## 3. Configure Terraform Backend

The Terraform backend is configured in `provider.tf` using an S3 backend block.

```hcl
backend "s3" {
  bucket         = "<YOUR_BUCKET_NAME>"
  key            = "terraform.tfstate"
  region         = "<YOUR_REGION>"
  dynamodb_table = "tf-lock"
  encrypt        = true
}
```

⚠️ Region must match bootstrap.

---

## 4. CI Pipeline (Build & Push Docker Image)

Workflow builds and pushes image to ECR.

### Trigger
- push to main
- changes in docker/**

### Required GitHub Settings

`Variables:`
- AWS_REGION
- ECR_REPOSITORY

`Secrets:`
- OIDC_ARN

`Behavior:`
- builds Docker image
- tags with GITHUB_SHA
- pushes to ECR

-> No dummy image needed anymore ✔

---

## 5. Prepare Terraform Variables

Copy the following template:
```bash
cp infra/terraform.tfvars.template infra/terraform.tfvars
```

### Minimal example
```hcl
# Region
region = "eu-central-1"

# Health Check
health_path = "/src/app/api/heartbeat"

# ECS
app_image      = "530193444530.dkr.ecr.eu-central-1.amazonaws.com/umami-repo:<IMAGE_TAG>"
desired_count  = 3   # Desired number of ECS tasks 
container_port = 3000

# Domain
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"
```

### Important

- ✔ Use immutable image tags (Git SHA)
- ❌ Never use latest

---

## 6. CD Pipeline (Terraform Deployment)

`Workflow:`
- terraform fmt
- terraform validate
- terraform plan
- terraform apply

### Required GitHub Settings

CD deploys infrastructure manually via workflow_dispatch.

Deployments to production require manual approval via GitHub Environments (required reviewers enabled).

`Variables:`
- AWS_REGION

`Secrets:`
- OIDC_ARN
- DB_STRING
- CLOUDFLARE_API_TOKEN
- ZONE_ID_CLOUDFLARE

Allow GitHub Actions to generate an `OIDC token`
```yaml
permissions:
  id-token: write
  contents: read
```

Terraform automatically creates a `DNS record`:
```hcl
resource "cloudflare_dns_record" "alb_dns_record" {
  zone_id = var.zone_id_cloudflare
  name    = var.subdomain_name
  ttl     = 1
  type    = "CNAME"
  content = var.alb_dns
  proxied = false
```

-> Traffic is routed to ALB.

---

## 7. Deployment Flow

```text
GitHub Actions (CI)
   ↓
Docker Build → ECR (tagged with SHA)
   ↓
Terraform Apply (CD)
   ↓
ECS Fargate
   ↓
ALB
   ↓
Cloudflare DNS
```

---

## 8. Access

### After deployment:
```text
https://<subdomain>.<domain>
```

### Example:
```text
https://tm.nashar.dev
```

---

## 9. Common Issues

### ECR not found

→ bootstrap not executed or wrong region

### Terraform backend error

→ wrong S3 bucket / region mismatch

### ALB not reachable

→ DNS propagation delay or wrong Cloudflare config

### ECS not starting

→ check logs (CloudWatch) and environment variables

---

## 11. Notes

- Bootstrap is run only once
- CI builds images automatically
- CD deploys infrastructure manually (via workflow_dispatch)
- Infrastructure and application are fully decoupled
