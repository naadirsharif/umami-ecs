# Region
region = "eu-central-1"

# Health Check
health_path = "/src/app/api/heartbeat"

# ECS task
app_image        = "nginx:latest" # dummy image (only local dev)
desired_count    = 0              # Desired number of ECS tasks 
container_port   = 3000
container_cpu    = 1024
container_memory = 2048

# Domain 
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"


