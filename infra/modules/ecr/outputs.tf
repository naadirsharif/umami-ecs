output "repo_arn" {
    description = "ARN of the repository"
    value       = aws_ecr_repository.app_repo.arn
}

output "repo_url" {
    description = "Url of the repository"
    value       = aws_ecr_repository.app_repo.repository_url
}