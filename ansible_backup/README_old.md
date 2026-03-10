# Ansible Automation

This folder contains automation playbooks that run kubectl commands.

Files:
- playbooks/deploy_env.yml : deploy + verify (env=dev or env=prod)
- playbooks/cleanup.yml    : cleanup (delete resources)

Usage (example):
ansible-playbook -i localhost, playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2
