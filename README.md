# Umami ECS Deployment Project 
This project deploys Umami, a modern, self-hosted analytics platform, on AWS ECS (Fargate) using modular Terraform and Github Actions CI/CD pipelines.

## Local Testing

```bash 
# Build container
docker build -t umami:latest -f docker/Dockerfile .

# Run locally
docker run -p 3000:3000 \
  -e DATABASE_URL=<database-url> \
  -e HOST=0.0.0.0 \
  umami:latest

# Access app via browser
http://localhost:3000
```


![<video controls src="images/umami-showcase.mov" title="Title"></video>](images/umami-showcase.gif)
