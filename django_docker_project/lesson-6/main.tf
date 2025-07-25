terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "s3_backend" {
  source = "./modules/s3-backend"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = "django-app"
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = "django-cluster"
  cluster_role_arn = "arn:aws:iam::885545924441:role/eksClusterRole"
  node_role_arn = "arn:aws:iam::885545924441:role/eksNodeRole"
  
  subnet_ids       = module.vpc.public_subnets
}

