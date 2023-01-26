# configure aws provider
provider "aws" {
    region      = var.region
    profile     = "default"
}

# create vpc
module "vpc" {
  source                                    = "../modules/vpc"
  region                                    = var.region
  project_name                              = var.project_name
  prod-vpc_cidir                            = var.prod-vpc_cidir
  Prod-NAT-ALB-Sbn_az1_cidir                = var.Prod-NAT-ALB-Sbn_az1_cidir
  Prod-NAT-ALB-Sbn_az2_cidir                = var.Prod-NAT-ALB-Sbn_az2_cidir
  Prod-webserver-Sbn_az1_cidir              = var.Prod-webserver-Sbn_az1_cidir
  Prod-webserver-Sbn_az2_cidir              = var.Prod-webserver-Sbn_az2_cidir
  Prod-Appserver-Sbn_az1_cidir              = var.Prod-Appserver-Sbn_az1_cidir
  Prod-Appserver-Sbn_az2_cidir              = var.Prod-Appserver-Sbn_az2_cidir
  Prod-databbase-Sbn_az1_cidir              = var.Prod-databbase-Sbn_az1_cidir
  Prod-databbase-Sbn_az2_cidir              = var.Prod-databbase-Sbn_az2_cidir
}

# create na-gateway
module "nat_gateway" {
  source                                    = "../modules/nat-gateway"
  Prod-NAT-ALB-Sbn_az1_id                   = module.vpc.Prod-NAT-ALB-Sbn_az1_id
  internet_gateway                          = module.vpc.internet_gateway
  Prod-NAT-ALB-Sbn_az2_id                   = module.vpc.Prod-NAT-ALB-Sbn_az2_id 
  prod-vpc_id                               = module.vpc.prod-vpc_id
  Prod-webserver-Sbn_az1_id                 = module.vpc.Prod-webserver-Sbn_az1_id
  Prod-webserver-Sbn_az2_id                 = module.vpc.Prod-webserver-Sbn_az2_id
  Prod-Appserver-Sbn_az1_id                 = module.vpc.Prod-Appserver-Sbn_az1_id
  Prod-Appserver-Sbn_az2_id                 = module.vpc.Prod-Appserver-Sbn_az2_id
  Prod-databbase-Sbn_az1_id                 = module.vpc.Prod-databbase-Sbn_az1_id
  Prod-databbase-Sbn_az2_id                 = module.vpc.Prod-databbase-Sbn_az2_id

}

# create sg
module "security_group" {
  source                                    = "../modules/security-groups"
  prod-vpc_id                               = module.vpc.prod-vpc_id
}

# create acm
module "acm" {
  source                                    = "../modules/acm"
  domain_name                               = var.domain_name
  alternative_name                          = var.alternative_name
}

# create ALB
module "Application_load_balancer" {
  source                                    = "../modules/alb"
  project_name                              = module.vpc.project_name
  frontend-lb_security_group_id             = module.security_group.frontend-lb_security_group_id
  backend-alb_security_group_id             = module.security_group.backend-alb_security_group_id
  Prod-NAT-ALB-Sbn_az1_id                   = module.vpc.Prod-NAT-ALB-Sbn_az1_id
  Prod-NAT-ALB-Sbn_az2_id                   = module.vpc.Prod-NAT-ALB-Sbn_az2_id
  Prod-webserver-Sbn_az1_id                 = module.vpc.Prod-webserver-Sbn_az1_id
  Prod-webserver-Sbn_az2_id                 = module.vpc.Prod-webserver-Sbn_az2_id
  prod-vpc_id                               = module.vpc.prod-vpc_id
  certificate_arn                           = module.acm.certificate_arn
}

# create asg
module "asg" {
  source                                    = "../modules/asg"
  project_name = module.vpc.project_name
  Prod-NAT-ALB-Sbn_az1_id = module.vpc.Prod-NAT-ALB-Sbn_az1_id
  bastionHost_security_group_id = module.security_group.bastionHost_security_group_id
  Prod-webserver-Sbn_az1_id = module.vpc.Prod-webserver-Sbn_az1_id
  Prod-webserver-Sbn_az2_id = module.vpc.Prod-webserver-Sbn_az2_id
  Prod-Appserver-Sbn_az1_id = module.vpc.Prod-Appserver-Sbn_az1_id
  Prod-Appserver-Sbn_az2_id = module.vpc.Prod-Appserver-Sbn_az2_id
  Prod-databbase-Sbn_az1_id = module.vpc.Prod-databbase-Sbn_az1_id
  Prod-databbase-Sbn_az2_id = module.vpc.Prod-databbase-Sbn_az2_id
  frontend-alb_target_group_arn = module.Application_load_balancer.frontend-alb_target_group_arn
  max_size = var.max_size
  min_size = var.min_size
  key_name = var.key_name
  desired_capacity = var.desired_capacity
}



