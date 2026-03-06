# Voting App DevOps Project (Linux + Docker + Kubernetes + Ansible)

This repository is an end-to-end DevOps project that deploys a microservices **Voting Application** on Kubernetes using **Ansible automation**.

**What you will see here**
- Clear microservices architecture (Frontend / Backend / Data)
- Kubernetes manifests split into environments (base / dev / prod)
- Ansible playbooks (deploy + verify + cleanup)
- Security best practices (Secrets, PV/PVC, Probes, NetworkPolicies, SecurityContext)

---

## Architecture (Frontend / Backend / Data)

### Frontend Layer (User Facing)
- **Vote App (Python)**: user submits votes
- **Result App (NodeJS)**: user views results

Exposed via Kubernetes **NodePort**:
- Vote   -> `31000`
- Result -> `31001`

### Backend Layer (Processing)
- **Worker (.NET)**: reads votes from Redis and stores results into PostgreSQL.

### Data Layer (Storage)
- **Redis**: queue/buffer (decouples frontend from DB)
- **PostgreSQL**: persistent DB (PV/PVC)

**Flow**
`USER -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

Diagram:
- `architecture/architecture.svg`

---

## Tech Stack
Linux, Docker, Kubernetes (kubectl), Ansible, Redis, PostgreSQL, Python, NodeJS, .NET

---

## Repository Structure (Quick Map)
- `kubernetes/` : manifests (base/dev/prod)
- `ansible/`    : automation playbooks
- `scripts/`    : helper scripts (optional)
- `docs/`       : architecture + security review + meeting pitch
- `architecture/` : diagram
- `frontend/ backend/ data/` : architecture mapping folders for reviewers
- `security/`   : security notes and policy references

---

## Quick Start (DEV)

### 1) Get node IP
```bash
kubectl get nodes -o wide
```

### 2) Deploy using Ansible
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2
```

### 3) Access
- http://172.18.0.2:31000
- http://172.18.0.2:31001

Quick check:
```bash
curl -I http://172.18.0.2:31000
curl -I http://172.18.0.2:31001
```

### 4) Verify
```bash
kubectl get pods -n voting
kubectl get svc -n voting
kubectl get networkpolicy -n voting
```

---

## Deploy (PROD)
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=prod -e node_ip=172.18.0.2
```

---

## Cleanup
```bash
ansible-playbook -i localhost, ansible/playbooks/cleanup.yml
```

---

## Security Highlights (Implemented)
- Secret for DB password: `kubernetes/dev/db-secret.yaml`
- PV/PVC for Postgres persistence: `postgres-pv.yaml` + `postgres-pvc.yaml`
- Health Probes: readiness/liveness
- NetworkPolicies (dev): default deny + allow only what is needed
- SecurityContext hardening (no privilege escalation, drop caps, seccomp)

---

## Reference
https://github.com/nexusameer/Voting-App-Microservices
