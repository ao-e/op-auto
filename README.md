# Secrets Management Scripts

This repository contains scripts to securely store and retrieve sensitive files using 1Password CLI.

## Usage

### Prerequisites
- Ensure the 1Password CLI (`op`) is installed and authenticated using `op signin`.

### Fetch Secrets
To fetch secrets for a particular environment, use the `retrieve_secrets.sh` script.

```sh
./scripts/retrieve_secrets.sh <environment>

```

## Integration Methods

### 1. Direct Copy Method
The simplest way to incorporate these scripts into your project:
