# Production environment - main.tf

provider "aws" {
  region = var.aws_region
}

# Reference to the root module
module "root" {
  source = "../../"
  
  aws_region  = var.aws_region
  environment = "prod"
}

# Additional production-specific resources can be defined here