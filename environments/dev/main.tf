terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.33"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  enable_nat_gateway = var.enable_nat_gateway
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  tags               = var.tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = var.vpc_cidr
  bastion_ssh_cidr = var.bastion_ssh_cidr
  tags             = var.tags
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  public_subnet_id          = module.vpc.public_subnet_ids[0]
  private_subnet_ids        = module.vpc.private_subnet_ids
  bastion_sg_id             = module.security_groups.bastion_sg_id
  app_sg_id                 = module.security_groups.app_sg_id
  iam_instance_profile_name = module.iam.instance_profile_name

  key_name              = var.key_name
  ami_id                = var.app_ami_id
  bastion_instance_type = var.bastion_instance_type
  app_instance_type     = var.app_instance_type
  app_instance_count    = var.app_instance_count
}

module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  app_instance_ids  = module.ec2.app_instance_ids
}

module "observability" {
  source = "../../modules/observability"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  app_instance_ids      = module.ec2.app_instance_ids
  log_retention_days    = var.log_retention_days
  alarm_email           = var.alarm_email
  cpu_threshold_percent = var.cpu_threshold_percent
}
