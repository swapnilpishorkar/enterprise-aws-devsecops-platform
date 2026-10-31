
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Project     = "Enterprise-DevSecOps-Platform"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}


module "vpc" {
  source = "../../modules/vpc"

  project_name         = "enterprise-devsecops"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = "enterprise-devsecops"
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  project_name = "enterprise-devsecops"
}
