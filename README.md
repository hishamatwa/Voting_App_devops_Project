# Voting App DevOps Project  
Linux + Docker + Kubernetes + Ansible

This repository contains an end-to-end DevOps project for deploying a microservices-based **Voting Application** on Kubernetes using **Ansible automation**.

## Project Overview

This project demonstrates:

- a clear microservices architecture
- Kubernetes manifests organized by environment
- Ansible playbooks for deployment and cleanup
- persistence for PostgreSQL
- health checks and container hardening
- security-focused configuration for local demo environments

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
- `ansible/` – Ansible playbooks for deploy and cleanup
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
