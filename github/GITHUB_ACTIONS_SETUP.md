# GitHub Actions CI/CD Setup Guide

This document explains how to set up the GitHub Actions CI/CD workflow for this Terraform project.

## Workflow Overview

The CI/CD pipeline performs the following tasks:

1. **Validate**: Checks Terraform formatting and validates the configuration
2. **Plan**: Generates execution plans for each environment (dev, staging, prod)
3. **Apply**: Applies the changes to the appropriate environment based on conditions

## Environment Deployment Rules

- **Dev**: Automatically deployed when changes are pushed to the `develop` branch
- **Staging**: Automatically deployed when changes are pushed to the `main` branch
- **Production**: Only deployed manually via workflow dispatch with approval

## Required GitHub Secrets

To use this workflow, you need to set up the following secrets in your GitHub repository:

1. **AWS Credentials**:
   - `AWS_ACCESS_KEY_ID`: AWS access key with permissions to create/modify resources
   - `AWS_SECRET_ACCESS_KEY`: Corresponding AWS secret key
   - `AWS_REGION`: Default AWS region (e.g., `us-east-1`)

2. **Terraform State Management**:
   - `TF_STATE_BUCKET`: Name of the S3 bucket for Terraform state
   - `TF_LOCK_TABLE`: Name of the DynamoDB table for state locking

## Setting Up GitHub Environments

For proper approval workflows and environment-specific secrets, set up the following GitHub environments:

1. **dev**: For development deployments
2. **staging**: For staging deployments
3. **prod**: For production deployments (add required reviewers for approval)

### How to Set Up GitHub Environments

1. Go to your repository on GitHub
2. Click on "Settings" > "Environments"
3. Click "New environment"
4. Enter the environment name (dev, staging, or prod)
5. For production, enable "Required reviewers" and add appropriate team members
6. Add any environment-specific secrets if needed

## Manual Deployment

To manually trigger a deployment to a specific environment:

1. Go to the "Actions" tab in your GitHub repository
2. Select the "Terraform CI/CD" workflow
3. Click "Run workflow"
4. Select the branch to run from
5. Choose the target environment (dev, staging, or prod)
6. Click "Run workflow"

## Best Practices

1. Always create pull requests for infrastructure changes
2. Review the Terraform plan output in the PR comments before merging
3. Use branch protection rules to enforce code reviews
4. Regularly rotate AWS credentials used in GitHub Secrets