# ------------------------------------------------------------
# GitHub Actions IAM Permissions (OIDC)
# Defines what GitHub Actions is allowed to do in AWS
# ------------------------------------------------------------


# OIDC provider for GitHub → enables keyless authentication
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

# IAM role assumed by GitHub Actions (restricted to a repository)
resource "aws_iam_role" "github_actions" {
  name = var.oidc_iam_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })
}




# ECR access (build & push container images)
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# ECS access (services, tasks, clusters)
resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# EC2 / VPC access (networking, subnets, SGs)
resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Load balancer access
resource "aws_iam_role_policy_attachment" "elb" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

# Certificate management (TLS via ACM) access
resource "aws_iam_role_policy_attachment" "acm" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
}

# Cloudwatch Logs access
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Parameter store access (secrets via SSM)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# Terraform state access (S3 backend)
resource "aws_iam_policy" "terraform_state" {
  name = "terraform-state-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.tf_state.arn,
          "${aws_s3_bucket.tf_state.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_state_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_state.arn
}


# Terraform state locking access (DynamoDB)
resource "aws_iam_policy" "terraform_dynamodb_lock" {
  name = "terraform-dynamodb-lock-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ]
        Resource = aws_dynamodb_table.tf_lock.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_dynamodb_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_dynamodb_lock.arn
}


# Pass ECS task execution role to services (required for ECS deployments)
resource "aws_iam_role_policy" "passrole" {
  name = "github-actions-passrole"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::${var.aws_account_id}:role/ecs_execution_role" # wil be created in root
      }
    ]
  })
}

# Allow GitHub Actions to create ECS roles
resource "aws_iam_role_policy" "ecs_iam_create" {
  name = "github-actions-ecs-iam"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:TagRole"
        ]
        Resource = "arn:aws:iam::${var.aws_account_id}:role/ecs_*"
      }
    ]
  })
}

# IAM read access for ECS role management
resource "aws_iam_role_policy" "ecs_iam_read" {
  name = "github-actions-ecs-iam-read"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
        ]
        Resource = "*"
      }
    ]
  })
}