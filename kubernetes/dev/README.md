# kubernetes/dev

This folder contains the Kubernetes manifests for the local demo environment of the Voting App.

## Purpose

This environment is designed to work reliably on a local kind cluster or a single-node Kubernetes setup.

It provides a more complete setup than `kubernetes/base` while still being simple enough for local testing and demonstration.

## Included Components

### Database
- `db-deployment.yaml`
- `db-service.yaml`
- `db-secret.yaml`
- `postgres-pv.yaml`
- `postgres-pvc.yaml`

PostgreSQL is used as the persistent database for final vote results.

### Redis
- `redis-deployment.yaml`
- `redis-service.yaml`

Redis is used as a temporary fast data layer between the vote service and the worker.

### Frontend
- `vote-deployment.yaml`
- `vote-service.yaml`
- `result-deployment.yaml`
- `result-service.yaml`

These services are exposed externally for user access.

### Backend
- `worker-deployment.yaml`

The worker reads votes from Redis and stores processed results in PostgreSQL.

### Network Policies
- `networkpolicy-deny.yaml`
- `networkpolicy-allow.yaml`

These policies restrict ingress traffic and allow only the required communication paths.

## Security Features

This folder includes:
- PostgreSQL password stored in a Kubernetes Secret
- `allowPrivilegeEscalation: false`
- dropped unnecessary Linux capabilities
- `seccompProfile: RuntimeDefault`
- NetworkPolicy-based ingress control

Frontend containers add only:
- `NET_BIND_SERVICE`

This is required because they listen on port `80`.

## Health Checks

Application health is monitored using:
- `readinessProbe`
- `livenessProbe`

These help Kubernetes know:
- when a container is ready to receive traffic
- when a container should be restarted

## Storage Design

### PostgreSQL
PostgreSQL uses persistent storage:
- `PersistentVolume (PV)` provides the actual storage
- `PersistentVolumeClaim (PVC)` requests that storage

This keeps database data available even if the PostgreSQL pod restarts.

### Redis
Redis uses `emptyDir`, which is temporary storage attached to the pod lifecycle.

This is acceptable because Redis is used only as a temporary processing layer, not as the final database.

## Network Access

Frontend services are exposed using NodePort:
- `vote` -> `31000`
- `result` -> `31001`

Internal services remain inside the cluster:
- `db` -> ClusterIP
- `redis` -> ClusterIP

## Network Policy Model

The NetworkPolicy setup follows this logic:
- deny ingress by default
- allow internal traffic inside the namespace
- allow external traffic only to:
  - `vote`
  - `result`

This reduces unnecessary exposure of internal services.

## Application Flow

`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Notes

This is the recommended environment for the local demo.

It is more complete than `kubernetes/base` and demonstrates:
- persistence
- service separation
- health probes
- basic Kubernetes security hardening
- controlled external access
