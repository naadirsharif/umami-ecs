# Region
region = "eu-central-1"

# Health Check
health_path = "/src/app/api/heartbeat"

# ECS 
app_image      = "530193444530.dkr.ecr.eu-central-1.amazonaws.com/umami-repo:906040cab488a91561150ff6be50af51dad02b89"
desired_count  = 3 # Desired number of ECS tasks for service
container_port = 3000

# Domain 
domain_name    = "nashar.dev"
subdomain_name = "tm"

acm_validation_method = "DNS"


