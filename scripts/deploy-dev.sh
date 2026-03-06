#!/usr/bin/env bash
set -e
NODE_IP="${1:-172.18.0.2}"
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip="$NODE_IP"
