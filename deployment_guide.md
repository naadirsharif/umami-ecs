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
- AWS account with permissions for: ECS / ECR, IAM, S3, DynamoDB, ALB, ACM, SSM
- Domain managed via Cloudflare + API Token (DNS is automated via Terraform) 
- PostgreSQL database (e.g. Neon, RDS, Supabase) with connection string
- Terraform (for bootstrap only)
- Docker (optional for local testing)

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
var.aws_account_id
  ID of your AWS Account

  Enter a value: 512346721367

var.region
  AWS Region

  Enter a value: eu-central-1

var.github_repo
  GitHub repository in the format 'owner/repo' that is allowed to assume IAM role via GitHub Actions OIDC

  Enter a value: naadirsharif/umami-ecs
```

Outputs (save these for later configurations!)
- state_bucket
- ecr_repo_url
- oidc_role_arn

---

## 3. Configure Terraform Backend

The Terraform backend is configured in `provider.tf` in the root, using an S3 backend block.

```hcl
backend "s3" {
  bucket         = "<YOUR_BUCKET_NAME>"
  key            = "terraform.tfstate"
  region         = "<YOUR_REGION>"
  dynamodb_table = "tf-lock"
  encrypt        = true
}
```

**Important:** Region must match bootstrap.

---

## 4. Prepare Terraform Variables

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
app_image        = "nginx:latest" # dummy (only used for local testing)
desired_count    = 3
container_port   = 3000
container_cpu    = 1024
container_memory = 2048

# Domain
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"
```

### Important

- app_image is overwritten automatically in CI/CD
- Actual image comes from ECR (tagged with Git SHA)

---

## 5. CI Pipeline (Build & Push Docker Image)

Builds and publishes the Docker image to Amazon ECR.

### Trigger
- push to `main` (changes in `app/` or `docker/`)
- manual (`workflow_dispatch`)

### Required GitHub Settings

**Variables**
- AWS_REGION
- ECR_REPOSITORY

**Secrets**
- OIDC_ARN

### Behavior
- builds Docker image (multi-stage)
- tags image with immutable `GITHUB_SHA`
- runs **Trivy security scan** (fails on critical vulnerabilities)
- pushes image to Amazon ECR

---

## 6. CD Pipeline (Terraform Deployment)

Deploys infrastructure and application using Terraform.

### Trigger
- automatically after successful CI run  
- optional manual trigger (`workflow_dispatch`) for redeploy / rollback

### Image Flow
- CI builds and pushes image → ECR (`GITHUB_SHA`)
- CD automatically injects image into Terraform via `TF_VAR_app_image`

### Pipeline Steps
- terraform fmt
- terraform validate
- **Checkov (security scan)**
- terraform plan
- terraform apply (after approval)

### Required GitHub Settings

**Variables**
- AWS_REGION
- ECR_URL

**Secrets**
- OIDC_ARN
- DB_STRING
- CLOUDFLARE_API_TOKEN
- ZONE_ID_CLOUDFLARE

### Manual Deployment / Rollback

You can also manually trigger the CD pipeline via:
**GitHub Actions → Run workflow** (workflow_dispatch)

This allows you to perform **rollbacks** using a previous image tag (Git SHA)

---

## 7. Access

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

#### ECR not found

→ bootstrap not executed or wrong region

#### Terraform backend error

→ wrong S3 bucket / region mismatch

#### ALB not reachable

→ DNS propagation delay or wrong Cloudflare config

#### ECS not starting

→ check logs (CloudWatch) and environment variables

---

## 10. Destroy Infrastructure (Cleanup)

**Before Destroying**, make sure the following points are met:
1. Scale ECS service to 0
2. Wait for tasks to drain
3. Ensure Target Groups are empty
4. Destroy Terraform infrastructure

Infrastructure can be destroyed using the destroy.yml GitHub Actions workflow:

→ Go to **Actions → "Destroy Terraform Infrastructure" → Run workflow**

### ⚠️
- This will delete all infrastructure managed by the main Terraform stack (ECS, ALB, VPC, etc.)
- Bootstrap resources (S3 state bucket, DynamoDB lock table, ECR repository, OIDC rules) are NOT deleted 
- Container images stored in ECR are preserved
