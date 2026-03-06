# Voting App DevOps Project (Linux + Docker + Kubernetes + Ansible)

## Architecture (Frontend / Backend / Data)

Frontend:
- Vote App (Python)
- Result App (NodeJS)
Exposed using NodePort services.

Backend:
- Worker (.NET)

Data:
- Redis (queue)
- PostgreSQL (database with PV/PVC)

Flow:
USER -> Vote -> Redis -> Worker -> PostgreSQL -> Result

Diagram:
architecture/architecture.svg

## Folders
ansible/      : Ansible automation playbooks
kubernetes/   : Kubernetes manifests (base/dev/prod)
docs/         : Architecture + Security review + Meeting pitch
scripts/      : helper scripts
architecture/ : diagram

## Run (DEV)
Deploy:
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2

Access:
http://172.18.0.2:31000
http://172.18.0.2:31001

Cleanup:
ansible-playbook -i localhost, ansible/playbooks/cleanup.yml
