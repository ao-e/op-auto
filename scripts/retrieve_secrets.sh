#!/usr/bin/env bash

set -euo pipefail

# Source common variables and functions
source "$(dirname "$0")/common.sh"

# Function to retrieve files from 1Password documents with checksum comparison
retrieve_files_from_1password() {
    local file_paths=("$@")

    for file_path in "${file_paths[@]}"; do
        original_file_name=$(basename "$file_path")
        document_name="${REPO_NAME}_${original_file_name}"

        mkdir -p "$(dirname "$file_path")"

        if [ -f "$file_path" ]; then
            local_checksum=$(sha256sum "$file_path" | awk '{ print $1 }')
            remote_checksum=$(op document get "$document_name" --vault "$VAULT_NAME" | sha256sum | awk '{ print $1 }')

            if [ "$local_checksum" == "$remote_checksum" ]; then
                echo "No update needed for '$file_path'. Files are identical."
                continue
            else
                echo "File '$file_path' has changed. Updating..."
            fi
        else
            echo "File '$file_path' does not exist. Retrieving..."
        fi

        op document get "$document_name" --vault "$VAULT_NAME" --output "$file_path"
        chmod 600 "$file_path"
        echo "File '$file_path' has been updated."
    done
}

# Main execution
check_1password_auth
read_sensitive_files
retrieve_files_from_1password "${file_paths[@]}"

echo "All secrets have been retrieved and written to their respective files."
