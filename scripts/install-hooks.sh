#!/bin/bash
# Script to install git hooks

set -e

HOOK_DIR=$(git rev-parse --git-dir)/hooks
SCRIPT_DIR=$(dirname "$0")

echo "Installing pre-commit hook..."

# Create pre-commit hook
cat > "${HOOK_DIR}/pre-commit" << 'EOF'
#!/bin/bash
# Pre-commit hook to validate Terraform configurations

echo "Running Terraform validation..."

# Run the validation script
./scripts/validate-terraform.sh

# Check if validation was successful
if [ $? -ne 0 ]; then
    echo "Error: Terraform validation failed. Commit aborted."
    exit 1
fi

echo "Terraform validation passed. Proceeding with commit."
exit 0
EOF

# Make the hook executable
chmod +x "${HOOK_DIR}/pre-commit"

echo "Git hooks installed successfully!"