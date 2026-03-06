
# Kubernetes Manifests

This folder contains Kubernetes YAML manifests for the Voting App.

## Environments
- `kubernetes/base/`
  - Minimal reference manifests (Deployments + Services only)

- `kubernetes/dev/`
  - Tuned for local kind / single-node clusters
  - Includes Secret + PV/PVC + NetworkPolicies + Probes + SecurityContext

- `kubernetes/prod/`
  - Production-ish example manifests
  - May require more CPU/memory than a small local cluster

## How deploy chooses dev/prod
Ansible uses:
- `-e env=dev`  -> applies `kubernetes/dev`
- `-e env=prod` -> applies `kubernetes/prod`

