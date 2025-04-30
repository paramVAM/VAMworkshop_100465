# Terraform Project with Modularity and State Management

This repository contains a Terraform project with a modular structure and state management configuration.

## Project Structure

```
.
├── param_100465.tf          # Main Terraform configuration file
├── modules/                 # Reusable Terraform modules
│   ├── networking/          # Networking infrastructure module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute/             # Compute resources module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/            # Environment-specific configurations
│   ├── dev/                 # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/             # Staging environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/                # Production environment
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── state/                   # State management configuration
│   ├── backend.tf
│   ├── provider.tf
│   └── variables.tf
├── scripts/                 # Utility scripts
│   ├── validate-terraform.sh # Script to validate Terraform configuration
│   └── install-hooks.sh     # Script to install Git hooks
├── tests/                   # Test scripts
│   └── github_actions_test.sh # Test for GitHub Actions workflow
└── .github/                 # GitHub specific files
    ├── workflows/           # GitHub Actions workflows
    │   └── terraform-ci-cd.yml  # CI/CD pipeline for Terraform
    └── GITHUB_ACTIONS_SETUP.md  # Setup guide for GitHub Actions
```

## Usage

### Local Validation

Before pushing changes, you can validate your Terraform configuration locally using the provided script:

```bash
# Make the script executable (first time only)
chmod +x scripts/validate-terraform.sh

# Run the validation script
./scripts/validate-terraform.sh
```

### Git Hooks

This repository includes a script to install Git hooks that automatically validate your Terraform configurations before each commit:

```bash
# Make the script executable (first time only)
chmod +x scripts/install-hooks.sh

# Install the Git hooks
./scripts/install-hooks.sh
```

### Testing

To test the GitHub Actions workflow configuration:

```bash
# Make the test script executable (first time only)
chmod +x tests/github_actions_test.sh

# Run the test
./tests/github_actions_test.sh
```

### Initialize and Apply

To deploy resources for a specific environment:

```bash
# Change to the desired environment directory
cd environments/dev

# Initialize Terraform
terraform init -backend-config="bucket=your-state-bucket" -backend-config="key=dev/terraform.tfstate" -backend-config="region=us-east-1" -backend-config="dynamodb_table=terraform-locks"

# Plan the deployment
terraform plan

# Apply the changes
terraform apply
```

### State Management

This project uses an S3 backend for state storage and a DynamoDB table for state locking. To set up the state management infrastructure:

```bash
# Change to the state directory
cd state

# Initialize and apply to create state resources
terraform init
terraform apply
```

## CI/CD Pipeline

This project includes a GitHub Actions workflow for continuous integration and deployment:

- **Validation**: All pull requests are validated for proper Terraform formatting and configuration
- **Planning**: Terraform plans are generated and added as comments to pull requests
- **Deployment**:
  - **Dev**: Automatically deployed when changes are pushed to the `develop` branch
  - **Staging**: Automatically deployed when changes are pushed to the `main` branch
  - **Production**: Only deployed manually via workflow dispatch with approval

For detailed setup instructions, see [GitHub Actions Setup Guide](.github/GITHUB_ACTIONS_SETUP.md).

## Modules

### Networking Module

Creates VPC, subnets, and networking components.

### Compute Module

Creates EC2 instances and security groups.
