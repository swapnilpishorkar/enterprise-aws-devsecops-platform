
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

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "enterprise-devsecops-app"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name     = "enterprise-devsecops-eks"
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  cluster_subnet_ids = module.vpc.private_subnet_ids
  node_subnet_ids    = module.vpc.public_subnet_ids

  cluster_public_access_cidrs = var.cluster_public_access_cidrs

  depends_on = [module.iam]
}
