# ECS module: creates cluster, task definition, service, IAM, SG and SSM parameter


## Cluster
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

## Log group
resource "aws_cloudwatch_log_group" "main" {
  name = "${var.cluster_name}-logs"
}

## Task definition 
resource "aws_ecs_task_definition" "main" {
  family                   = "umami-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

 
container_definitions = jsonencode([
  {
    name      = "umami-ecs"
    image     = var.app_image
    cpu       = 1024
    memory    = 2048
    essential = true

    environment = [
      {
        name  = "HOST"
        value = "0.0.0.0"
      }
    ]

    secrets = [
      {
        name      = "DATABASE_URL"
        valueFrom = aws_ssm_parameter.db_connection_string.arn
      }
    ]

    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-region        = var.region
        awslogs-stream-prefix = "umami-logs"
      }
    }
  }
])


  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  tags = var.tags
}


## Service 
resource "aws_ecs_service" "main" {
  name            = "umami"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.private_subnet_ids

    assign_public_ip = false
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    container_name   = "umami-ecs"
    container_port   = var.container_port
    target_group_arn = var.tg_arn
  }
  tags = var.tags
}
