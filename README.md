# Voting App DevOps Project
Linux + Docker + Kubernetes + Ansible

This repository contains an end-to-end DevOps project for deploying a microservices-based Voting Application on Kubernetes using Ansible automation.

## Project Overview

This project demonstrates:

- a clear microservices architecture
- Kubernetes manifests organized by environment
- Ansible playbooks for deployment and cleanup
- persistent storage for PostgreSQL
- health checks and container hardening
- security-focused configuration for the local demo environment

---

## Architecture

The application is divided into three main layers.

### Frontend Layer
User-facing services:

- **Vote App (Python)**: users submit votes
- **Result App (NodeJS)**: users view results

These services are exposed through Kubernetes **NodePort**:

- **Vote** -> `31000`
- **Result** -> `31001`

### Backend Layer
Processing service:

- **Worker (.NET)**: reads votes from Redis and stores processed results in PostgreSQL

### Data Layer
Storage services:

- **Redis**: temporary fast data layer used as a queue/buffer
- **PostgreSQL**: persistent database using PV/PVC

### Application Flow

`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

Architecture diagram:
- `architecture/architecture.svg`

---

## Tech Stack

- Linux
- Docker
- Kubernetes (`kubectl`)
- Ansible
- Redis
- PostgreSQL
- Python
- NodeJS
- .NET

---

## Repository Structure

- `kubernetes/` – Kubernetes manifests for `base`, `dev`, and `prod`
- `ansible/` – Ansible playbooks for deployment and cleanup
- `scripts/` – optional helper scripts
- `docs/` – architecture, security review, and meeting notes
- `architecture/` – architecture diagram
- `frontend/`, `backend/`, `data/` – reviewer-friendly architecture mapping
- `security/` – security notes and network policy files

---

## Kubernetes Environments

### `kubernetes/base`
Minimal reference manifests for learning and structure review.

### `kubernetes/dev`
Recommended local demo environment.

Includes:
- Secret for PostgreSQL password
- PersistentVolume and PersistentVolumeClaim
- readiness and liveness probes
- container hardening
- NetworkPolicies
- NodePort access for frontend services

### `kubernetes/prod`
Production-style manifests with stronger structure than `base`.

Includes:
- Secret for PostgreSQL password
- PersistentVolume and PersistentVolumeClaim
- readiness and liveness probes
- container hardening
- NodePort access for frontend services

Note:
- unlike `dev`, the current `prod` folder does not include the same NetworkPolicy setup

---

## Quick Start (DEV)

The `dev` environment is the recommended setup for local demos.

### 1) Get the node IP
```bash
kubectl get nodes -o wide

### 2) Deploy with Ansible
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2


3) Access the application

http://172.18.0.2:31000

http://172.18.0.2:31001

4) Quick check
curl -I http://172.18.0.2:31000
curl -I http://172.18.0.2:31001


5) Verify resources
kubectl get pods -n voting
kubectl get svc -n voting
kubectl get networkpolicy -n voting

Deploy (PROD)
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=prod -e node_ip=172.18.0.2


Cleanup
ansible-playbook -i localhost, ansible/playbooks/cleanup.yml

Security Highlights
Implemented security controls include:
Kubernetes Secret for PostgreSQL password
PV/PVC for PostgreSQL persistence
readiness and liveness probes
SecurityContext hardening:
allowPrivilegeEscalation: false
drop unnecessary Linux capabilities
seccompProfile: RuntimeDefault

NetworkPolicies in the dev environment:
default deny ingress
allow internal namespace communication
allow external access only to vote and result

Notes

dev is the recommended environment for local demos and presentations
base is mainly for learning and reference
prod is a more production-style layout, but may need additional improvements for full production readiness

### Project Reference

Based on the Voting App microservices idea:
https://github.com/nexusameer/Voting-App-Microservices

