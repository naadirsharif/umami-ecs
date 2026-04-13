# Region
region = "eu-central-1"

# Health Check
health_path = "/src/app/api/heartbeat"

# ECS 
desired_count  = 3              # Desired number of ECS tasks for service
app_image      = "nginx:latest" # Dummy image -> will be overwritten by CI/CD
container_port = 3000

# Domain 
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"


