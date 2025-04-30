#!/bin/bash
# Script to validate Terraform configuration locally

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Terraform validation...${NC}"

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Error: terraform is not installed or not in PATH${NC}"
    exit 1
fi

# Format check
echo -e "\n${YELLOW}Checking Terraform formatting...${NC}"
terraform fmt -check -recursive
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Terraform formatting is correct.${NC}"
else
    echo -e "${RED}Terraform formatting issues found. Run 'terraform fmt -recursive' to fix.${NC}"
    exit 1
fi

# Validate main configuration
echo -e "\n${YELLOW}Validating main Terraform configuration...${NC}"
terraform init -backend=false
terraform validate
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Main Terraform configuration is valid.${NC}"
else
    echo -e "${RED}Main Terraform configuration validation failed.${NC}"
    exit 1
fi

# Validate each environment
for env in dev staging prod; do
    echo -e "\n${YELLOW}Validating ${env} environment...${NC}"
    cd "environments/${env}" || exit 1
    terraform init -backend=false
    terraform validate
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${env} environment configuration is valid.${NC}"
    else
        echo -e "${RED}${env} environment configuration validation failed.${NC}"
        exit 1
    fi
    cd - > /dev/null || exit 1
done

echo -e "\n${GREEN}All Terraform configurations are valid!${NC}"
exit 0