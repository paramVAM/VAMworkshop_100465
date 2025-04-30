# param_100465.tf
# Main Terraform configuration file with modular structure

# Provider configuration
provider "aws" {
  region = var.aws_region
}

# Backend configuration for state management
terraform {
  backend "s3" {
    # These values would typically be initialized during terraform init
    # bucket = "terraform-state-bucket"
    # key    = "terraform.tfstate"
    # region = "us-east-1"
    # dynamodb_table = "terraform-locks"
  }
}

# Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Module references
module "networking" {
  source = "./modules/networking"
  
  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
}

module "compute" {
  source = "./modules/compute"
  
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.subnet_ids
}

# Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "instance_ids" {
  description = "IDs of created instances"
  value       = module.compute.instance_ids
}