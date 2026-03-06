#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

NODE_IP="${1:-172.18.0.2}"

ansible-playbook -i localhost, "${PROJECT_ROOT}/ansible/playbooks/deploy_env.yml" \
  -e env=dev \
  -e node_ip="${NODE_IP}"
