# Security

This folder contains the main security-related configurations used by the Voting App.

## Purpose

The security configuration is designed to reduce unnecessary exposure, protect sensitive values, and harden running containers.

## Implemented Security Controls

### 1. Kubernetes Secret for database password
The PostgreSQL password is stored in a Kubernetes Secret (`db-secret`) instead of being written directly in the Deployment manifest.

This improves separation between application configuration and sensitive data.

### 2. NetworkPolicies
The project uses Kubernetes NetworkPolicies to restrict ingress traffic.

Implemented rules:
- default deny ingress for all pods
- allow internal communication inside the namespace
- allow external access only to:
  - `vote`
  - `result`

This helps protect internal services such as:
- `db`
- `redis`

from unnecessary external access.

### 3. Container hardening with SecurityContext
Several workloads use container security hardening, including:
- `allowPrivilegeEscalation: false`
- dropping unnecessary Linux capabilities
- adding `NET_BIND_SERVICE` only where needed
- `seccompProfile: RuntimeDefault`

`NET_BIND_SERVICE` is added only for frontend services that bind to port `80`, such as:
- `vote`
- `result`

## Security Goal

The overall goal is to apply basic Kubernetes security good practices by:
- limiting exposed services
- protecting secrets
- reducing container privileges
- restricting network access

## Notes

- NetworkPolicies apply only if the cluster network plugin supports them
- Internal services should remain reachable only inside the cluster
- Frontend services are the only components intentionally exposed for user access
