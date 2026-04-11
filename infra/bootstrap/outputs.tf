output "ecr_repo_url" {
    description = "Url of the ECR repository"
    value       = aws_ecr_repository.app_repo.repository_url
}

output "oidc_arn" {
    description = "ARN of the OIDC IAM role"
    value = aws_iam_role.github_actions.arn
}

