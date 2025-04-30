#!/bin/bash
# Test script to validate GitHub Actions workflow file

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

WORKFLOW_FILE=".github/workflows/terraform-ci-cd.yml"

echo -e "${YELLOW}Testing GitHub Actions workflow file...${NC}"

# Check if the workflow file exists
if [ ! -f "$WORKFLOW_FILE" ]; then
    echo -e "${RED}Error: Workflow file not found at $WORKFLOW_FILE${NC}"
    exit 1
fi

# Check if the file is valid YAML
echo -e "\n${YELLOW}Checking if workflow file is valid YAML...${NC}"
if command -v yamllint &> /dev/null; then
    yamllint -d relaxed "$WORKFLOW_FILE" && echo -e "${GREEN}YAML syntax is valid.${NC}" || (echo -e "${RED}YAML syntax is invalid.${NC}" && exit 1)
else
    echo -e "${YELLOW}Warning: yamllint not installed, skipping YAML validation.${NC}"
fi

# Check for required jobs
echo -e "\n${YELLOW}Checking for required jobs in workflow...${NC}"
REQUIRED_JOBS=("validate" "plan-dev" "plan-staging" "plan-prod" "apply-dev" "apply-staging" "apply-prod")
MISSING_JOBS=()

for job in "${REQUIRED_JOBS[@]}"; do
    if ! grep -q "name: .*$job" "$WORKFLOW_FILE"; then
        MISSING_JOBS+=("$job")
    fi
done

if [ ${#MISSING_JOBS[@]} -eq 0 ]; then
    echo -e "${GREEN}All required jobs are present in the workflow.${NC}"
else
    echo -e "${RED}Error: The following required jobs are missing: ${MISSING_JOBS[*]}${NC}"
    exit 1
fi

# Check for required secrets
echo -e "\n${YELLOW}Checking for required secrets in workflow...${NC}"
REQUIRED_SECRETS=("AWS_ACCESS_KEY_ID" "AWS_SECRET_ACCESS_KEY" "TF_STATE_BUCKET" "TF_LOCK_TABLE" "AWS_REGION")
MISSING_SECRETS=()

for secret in "${REQUIRED_SECRETS[@]}"; do
    if ! grep -q "\${{ secrets.$secret }}" "$WORKFLOW_FILE"; then
        MISSING_SECRETS+=("$secret")
    fi
done

if [ ${#MISSING_SECRETS[@]} -eq 0 ]; then
    echo -e "${GREEN}All required secrets are referenced in the workflow.${NC}"
else
    echo -e "${RED}Error: The following required secrets are not referenced: ${MISSING_SECRETS[*]}${NC}"
    exit 1
fi

echo -e "\n${GREEN}GitHub Actions workflow file passed all tests!${NC}"
exit 0