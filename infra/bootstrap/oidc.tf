# GitHub OIDC Provider for AWS authentication via GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

# IAM role for GitHub Actions restricted to a specific repo for secure & keyless AWS access
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
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}

# Allow ECR Push for GitHub Actions
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# Allows ECS Deployment for GitHub Actions
resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# Allow GitHub Actions to access Terraform state stored in S3
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

# Allow access to dynamodb state locking to prevent simultaneous Terraform operations.
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


# Allow GitHub Actions to pass the ECS task role during deployment
resource "aws_iam_role_policy" "passrole" {
  name = "github-actions-passrole"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "*"
      }
    ]
  })
}
