# kubernetes/prod

This folder contains the production-style Kubernetes manifests for the Voting App.

## Purpose

This environment provides a more complete and structured Kubernetes setup than `kubernetes/base`.

It is designed to include:
- persistent PostgreSQL storage
- Secret-based database password management
- health probes for application readiness and liveness
- container security hardening
- internal service isolation with NetworkPolicy
- external access only for frontend services

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

This folder includes several security improvements:
- PostgreSQL password stored in a Kubernetes Secret
- `allowPrivilegeEscalation: false`
- unnecessary Linux capabilities dropped
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

### External
Frontend services are exposed using NodePort:
- `vote` -> `31000`
- `result` -> `31001`

### Internal
Data services are internal only:
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

This folder represents the stronger and more complete deployment setup compared with `kubernetes/base`.

It is suitable for demonstrating:
- persistence
- service separation
- health monitoring
- basic Kubernetes security hardening
- controlled external exposure
