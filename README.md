# Voting App DevOps Project

Linux • Docker • Kubernetes • Ansible

This repository demonstrates an **end-to-end DevOps workflow** for deploying a microservices-based Voting Application on Kubernetes using **Ansible automation**.

The project shows how to structure Kubernetes manifests, automate deployments, and apply basic container and network security practices.

---

# Project Overview

This project demonstrates:

- Microservices architecture
- Kubernetes manifests organized by environments
- Infrastructure automation using Ansible
- PostgreSQL persistence using PV/PVC
- Health checks using readiness and liveness probes
- Container security hardening
- Basic Kubernetes network security using NetworkPolicies

---

# Architecture

The application is composed of several services organized into layers.

## Frontend Layer

User-facing services:

- **Vote (Python)** – users submit votes
- **Result (NodeJS)** – users see voting results

Both services are exposed using **Kubernetes NodePort**.

```
Vote Service   -> Port 31000
Result Service -> Port 31001
```

---

## Backend Layer

Processing service:

- **Worker (.NET)**  
  Reads votes from Redis and writes results to PostgreSQL.

---

## Data Layer

Storage services:

- **Redis** – temporary queue for votes
- **PostgreSQL** – persistent storage for results

---

# Application Flow

```
User → Vote Service → Redis → Worker → PostgreSQL → Result Service
```

Architecture diagram:

```
architecture/architecture.svg
```

---

# Tech Stack

- Linux
- Docker
- Kubernetes (kubectl)
- Ansible
- Redis
- PostgreSQL
- Python
- NodeJS
- .NET

---

# Repository Structure

```
kubernetes/      Kubernetes manifests for base, dev, and prod
ansible/         Ansible automation (deploy, cleanup, variables, inventory)
architecture/    Architecture diagram
docs/            Documentation and notes
security/        Security configuration notes
scripts/         Optional helper scripts
frontend/        Architecture reference
backend/         Architecture reference
data/            Architecture reference
```

---

# Kubernetes Environments

## kubernetes/base

Minimal reference manifests used for learning and structure review.

---

## kubernetes/dev

Recommended **local development and demo environment**.

Includes:

- PostgreSQL Secret
- PersistentVolume and PersistentVolumeClaim
- readiness and liveness probes
- container security configuration
- NetworkPolicies
- NodePort services for frontend access

---

## kubernetes/prod

Production-style structure with similar configuration to dev.

Includes:

- PostgreSQL Secret
- PV/PVC configuration
- readiness and liveness probes
- container hardening
- NodePort services

Note:  
The dev environment currently includes stricter **NetworkPolicies** than prod.

---

# Quick Start (DEV)

The **dev environment** is recommended for local demonstrations.

## 1. Get the node IP

```
kubectl get nodes -o wide
```

Example:

```
172.18.0.2
```

---

## 2. Deploy using Ansible

```
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy.yml -e @ansible/vars/dev.yml
```

---

## 3. Access the application

```
http://172.18.0.2:31000
http://172.18.0.2:31001
```

---

## 4. Verify the application

```
curl -I http://172.18.0.2:31000
curl -I http://172.18.0.2:31001
```

---

## 5. Check Kubernetes resources

```
kubectl get pods -n voting
kubectl get svc -n voting
kubectl get networkpolicy -n voting
```

---

# Deploy Production Environment

```
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy.yml -e @ansible/vars/prod.yml
```

---

# Cleanup Deployment

```
ansible-playbook -i ansible/inventory.ini ansible/playbooks/cleanup.yml
```

---

# Security Highlights

Implemented security practices include:

- Kubernetes **Secrets** for database credentials
- **PersistentVolume / PersistentVolumeClaim** for database storage
- **Readiness and Liveness Probes**
- Container **SecurityContext hardening**

Container restrictions include:

```
allowPrivilegeEscalation: false
seccompProfile: RuntimeDefault
```

Network security:

- NetworkPolicies in the dev environment
- default deny ingress
- controlled communication between services
- external access limited to frontend services

---

# Notes

- **dev** is recommended for demos and development.
- **base** is mainly for learning and reference.
- **prod** represents a production-style structure but may require additional improvements for real production environments.

---

# Project Reference

Inspired by the Voting App microservices example:

https://github.com/nexusameer/Voting-App-Microservices
