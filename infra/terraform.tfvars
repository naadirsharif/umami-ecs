# Region
region = "eu-central-1"

# Health Check
health_path = "/src/app/api/heartbeat"

# ECS 
app_image      = "530193444530.dkr.ecr.eu-central-1.amazonaws.com/umami-repo:0b4e94f10400f06478f457b4d6933cbb7ef1465b"
desired_count  = 3 # Desired number of ECS tasks for service
container_port = 3000

# Domain 
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"


