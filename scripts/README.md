# Scripts

This folder contains optional helper scripts for running the Ansible playbooks more quickly.

## Purpose

These scripts are simple wrappers around the main Ansible commands.

They are useful for:
- reducing long command typing
- speeding up local demos
- making deployment steps easier for reviewers

## Files

### `deploy-dev.sh`
Deploys the development environment using:

- `ansible/playbooks/deploy_env.yml`
- `env=dev`

It accepts an optional node IP argument.

Example:
```bash
./scripts/deploy-dev.sh 172.18.0.2
