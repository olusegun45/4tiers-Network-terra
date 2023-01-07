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
  vpc_cidir                                 = var.vpc_cidir
  public_subnet-1_az1_cidir                 = var.public_subnet-1_az1_cidir
  public_subnet-2_az1_cidir                 = var.public_subnet-2_az1_cidir
  public_subnet-1_az2_cidir                 = var.public_subnet-1_az2_cidir
  public_subnet-2_az2_cidir                 = var.public_subnet-2_az2_cidir
  private_app_subnet_az1_cidir              = var.private_app_subnet_az1_cidir
  private_app_subnet_az2_cidir              = var.private_app_subnet_az2_cidir
  private_data_subnet_az1_cidir             = var.private_data_subnet_az1_cidir
  private_data_subnet_az2_cidir             = var.private_data_subnet_az2_cidir
}

# create na-gateway
module "nat_gateway" {
  source                                    = "../modules/nat-gateway"
  public_subnet-1_az1_id                    = module.vpc.public_subnet-1_az1_id 
  internet_gateway                          = module.vpc.internet_gateway
  public_subnet-1_az2_id                    = module.vpc.public_subnet-1_az2_id
  vpc_id                                    = module.vpc.vpc_id
  private_app_subnet_az1_id                 = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id                = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id                 = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id                = module.vpc.private_data_subnet_az2_id
}

# create sg
module "security_group" {
  source                                    = "../modules/security-groups"
  vpc_id                                    = module.vpc.vpc_id
}



