module "vpc" {
  source               = "./modules/vpc"
  tags                 = var.tags
  availability_zones   = var.availability_zones
  cidr_vpc             = var.cidr_vpc
  cidrs_public_subnet  = var.cidrs_public_subnet
  cidrs_private_subnet = var.cidrs_private_subnet
}

module "alb" {
  source          = "./modules/alb"
  tags            = var.tags
  tg_port         = var.tg_port
  health_path     = var.health_path
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  cert_arn        = module.acm.certificate_arn
  sg_name_alb     = var.sg_name_alb
  alb_sg_description = var.alb_sg_description
}

module "acm" {
  source      = "./modules/acm"
  tags        = var.tags
  domain_name = var.domain_name
  acm_validation_method = var.acm_validation_method
  zone_id = var.zone_id_cloudflare
}

module "ecs" {
  region               = var.region
  source               = "./modules/ecs"
  tags                 = var.tags
  app_image            = var.app_image
  cluster_name         = var.cluster_name
  alb_sg_id            = module.alb.alb_sg_id
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_string            = var.db_string
  tg_arn               = module.alb.ecs_target_group_arn
}

module "dns" {
  source = "./modules/dns"
  domain_name = var.domain_name
  alb_dns = module.alb.alb_dns_name
  zone_id = var.zone_id_cloudflare
}

