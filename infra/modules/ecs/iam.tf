# ECS IAM 

resource "aws_iam_role" "ecs_iam" {
  name = var.ecs_iam_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}

## Policy Attachment 

# ECR Pull
resource "aws_iam_role_policy_attachment" "ecr_pull" {
  role       = aws_iam_role.ecs_iam.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# CloudWatch Logs
resource "aws_iam_role_policy_attachment" "cw_logs" {
  role       = aws_iam_role.ecs_iam.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}