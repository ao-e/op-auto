#!/usr/bin/env bash

set -euo pipefail

# Source common variables and functions
source "$(dirname "$0")/common.sh"

# Use the default or custom sensitive files list
SENSITIVE_FILES_LIST="${SENSITIVE_FILES_LIST:-$REPO_ROOT/.sensitive_files.txt}"
GITIGNORE_FILE="$REPO_ROOT/.gitignore"

# Ensure .gitignore exists
touch "$GITIGNORE_FILE"

# Add a marker for the auto-generated section
MARKER_START="# BEGIN 1PASSWORD SECRETS MANAGER"
MARKER_END="# END 1PASSWORD SECRETS MANAGER"

# Remove existing auto-generated section
temp_file=$(mktemp)
sed "/$MARKER_START/,/$MARKER_END/d" "$GITIGNORE_FILE" > "$temp_file"
mv "$temp_file" "$GITIGNORE_FILE"

# Add new auto-generated section
{
    echo "$MARKER_START"
    echo "# Do not modify this section. It is auto-generated."
    while IFS= read -r file || [[ -n "$file" ]]; do
        [[ -z "$file" || "$file" =~ ^# ]] && continue
        echo "$file"
    done < "$SENSITIVE_FILES_LIST"
    echo "$MARKER_END"
} >> "$GITIGNORE_FILE"

echo "Updated .gitignore with files listed in $SENSITIVE_FILES_LIST"