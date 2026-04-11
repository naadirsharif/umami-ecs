# ECR module: creates container repository for app image

resource "aws_ecr_repository" "app_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "IMMUTABLE"

  force_delete = false

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}
