terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

# Route domain traffic to the ALB 
resource "cloudflare_dns_record" "alb_dns_record" {
  zone_id = var.zone_id
  name = "nashar.dev"
  ttl = 1
  type = "CNAME"
  content = var.alb_dns
  proxied = false
}

# ACM Validation 