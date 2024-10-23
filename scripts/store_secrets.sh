#!/usr/bin/env bash

set -euo pipefail

# Source common variables and functions
source "$(dirname "$0")/common.sh"

# Function to store files as 1Password documents, with content comparison
store_files_in_1password() {
    local file_paths=("$@")

    for file_path in "${file_paths[@]}"; do
        if [ -f "$file_path" ]; then
            document_name="${REPO_NAME}_$(basename "$file_path")"
            echo "Checking document '$document_name' from path '$file_path' in vault '$VAULT_NAME'..."

            if op document get "$document_name" --vault="$VAULT_NAME" &>/dev/null; then
                echo "Document '$document_name' already exists. Checking if update is needed..."

                local_checksum=$(sha256sum "$file_path" | awk '{ print $1 }')
                remote_checksum=$(op document get "$document_name" --vault "$VAULT_NAME" | sha256sum | awk '{ print $1 }')

                if [ "$local_checksum" == "$remote_checksum" ]; then
                    echo "No update needed for '$document_name'. Files are identical."
                    continue
                else
                    echo "Updating '$document_name' as the file content has changed..."
                    op document delete "$document_name" --vault "$VAULT_NAME"
                fi
            else
                echo "Document '$document_name' does not exist. Adding..."
            fi

            op document create "$file_path" --vault="$VAULT_NAME" --title "$document_name" --tags "$REPO_NAME"
        else
            echo "Warning: File '$file_path' not found. Skipping."
        fi
    done
}

# Main execution
check_1password_auth
read_sensitive_files
store_files_in_1password "${file_paths[@]}"

echo "All sensitive files have been securely stored in 1Password vault '$VAULT_NAME' with repository prefix '$REPO_NAME'."
