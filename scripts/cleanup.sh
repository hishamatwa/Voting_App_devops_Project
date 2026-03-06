#!/usr/bin/env bash
set -e
ansible-playbook -i localhost, ansible/playbooks/cleanup.yml
