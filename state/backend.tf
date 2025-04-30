# State management - backend.tf

# This file configures the backend for Terraform state
# It's referenced by the main configuration but values are typically
# provided during terraform init

terraform {
  backend "s3" {
    # These values would be provided during terraform init
    # bucket         = "terraform-state-bucket"
    # key            = "terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform-locks"
    # encrypt        = true
  }
}