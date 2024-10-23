#!/usr/bin/env bash

# Default environment is 'dev', but it can be overridden
ENVIRONMENT=${ENVIRONMENT:-dev}

# Vault and repository names with environment awareness
VAULT_NAME="Infrastructure-${ENVIRONMENT}"
REPO_NAME="${REPO_NAME:-$(basename "$(git rev-parse --show-toplevel)")}-${ENVIRONMENT}"

# Default path to the sensitive files list, allowing for override via an environment variable
SENSITIVE_FILES_LIST="${SENSITIVE_FILES_LIST:-./.sensitive_files.txt}"

# Function to check 1Password CLI authentication
check_1password_auth() {
    if ! op account get &>/dev/null; then
        echo "Error: Not authenticated with 1Password CLI. Please run 'op signin' first." >&2
        exit 1
    fi
}

# Function to read sensitive files list
read_sensitive_files() {
    file_paths=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        file_paths+=("$line")
    done < "$SENSITIVE_FILES_LIST"
}

# Trap and handle any errors
trap 'echo "Error occurred at line $LINENO"; exit 1' ERR
