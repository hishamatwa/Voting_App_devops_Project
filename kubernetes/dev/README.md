# kubernetes/dev (Local Demo - Recommended)

Purpose:
- Works reliably on local kind / single-node cluster.

Includes:
- Secret: `db-secret.yaml` for Postgres password
- Persistence: PV/PVC (`postgres-pv.yaml`, `postgres-pvc.yaml`)
- NetworkPolicies:
  - default deny ingress
  - allow internal namespace traffic
  - allow external ONLY to vote/result
- Health probes (readiness/liveness)
- SecurityContext hardening

Access:
- vote   -> NodePort 31000
- result -> NodePort 31001
