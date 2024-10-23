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
Download and set up the scripts directly in your project:
```sh
mkdir -p scripts/secrets
curl -O scripts/secrets/{store,retrieve,common,update_gitignore}.sh \
    https://raw.githubusercontent.com/your-repo/main/scripts/secrets/
chmod +x scripts/secrets/*.sh
```

### 2. Package Manager Integration
For Node.js projects, add to package.json:
```json
{
  "scripts": {
    "secrets:retrieve": "./scripts/secrets/retrieve_secrets.sh"
  },
  "devDependencies": {
    "op-secrets-manager": "github:your-org/op-secrets-manager#v1.0.0"
  }
}
```

### 3. Makefile Integration
Add to your Makefile:
```make
setup-secrets:
	@mkdir -p scripts/secrets
	@curl -O scripts/secrets/*.sh https://raw.githubusercontent.com/your-repo/main/scripts/secrets/
	@chmod +x scripts/secrets/*.sh
```

### 4. Docker Integration
Use a Dockerfile for secrets management:
```dockerfile
FROM alpine:3.18
RUN apk add --no-cache curl bash
COPY scripts/secrets /scripts
ENTRYPOINT ["/scripts/retrieve_secrets.sh"]
```

### 5. CI/CD Integration
Create a reusable workflow:
```yaml
name: Secrets Setup
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
jobs:
  setup-secrets:
    runs-on: ubuntu-latest
    steps:
      - name: Get Scripts
        run: |
          mkdir -p scripts/secrets
          curl -O scripts/secrets/*.sh https://raw.githubusercontent.com/your-repo/main/scripts/secrets/
          chmod +x scripts/secrets/*.sh
      - name: Retrieve Secrets
        env:
          ENVIRONMENT: ${{ inputs.environment }}
        run: ./scripts/secrets/retrieve_secrets.sh
```

## Best Practices

1. Version pin your script downloads:
```sh
SCRIPTS_VERSION="v1.0.0"
curl -O "https://raw.githubusercontent.com/your-repo/${SCRIPTS_VERSION}/scripts/secrets/common.sh"
```

2. Add local configurations:
```sh
# .secrets-config.local.sh
export VAULT_NAME="custom-vault"
export ENVIRONMENT="development"
```

3. Verify script integrity:
```sh
echo "${EXPECTED_SHA256} common.sh" | sha256sum --check
```

For more detailed documentation and examples, see the [Wiki](https://github.com/your-repo/wiki).
