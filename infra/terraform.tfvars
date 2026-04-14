# Region
region = "eu-central-1"

# Health Check
health_path = "/src/app/api/heartbeat"

# ECS 
app_image      = "530193444530.dkr.ecr.eu-central-1.amazonaws.com/umami-repo:fd3259bb9e079b5e8debac5cf99c70f3e9c728b6"
desired_count  = 0 # Desired number of ECS tasks for service
container_port = 3000

# Domain 
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"


