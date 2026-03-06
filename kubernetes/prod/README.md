# kubernetes/prod

This folder contains the production-style Kubernetes manifests for the Voting App.

## Purpose

This environment provides a structured Kubernetes setup for the application with persistence, health checks, and container hardening.

It is designed to demonstrate:
- persistent PostgreSQL storage
- Secret-based database password management
- health probes
- container security hardening
- internal data services with external frontend access

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

## Security Features

This folder includes:
- PostgreSQL password stored in a Kubernetes Secret
- `allowPrivilegeEscalation: false`
- unnecessary Linux capabilities dropped
- `seccompProfile: RuntimeDefault`

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

This helps preserve database data across pod restarts.

### Redis
Redis uses `emptyDir`, which is temporary storage tied to the pod lifecycle.

This is acceptable because Redis is used only as a temporary processing layer and not as the final database.

## Network Access

Frontend services are exposed using NodePort:
- `vote` -> `31000`
- `result` -> `31001`

Internal services remain inside the cluster:
- `db` -> ClusterIP
- `redis` -> ClusterIP

## Application Flow

`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Notes

This folder represents a more complete deployment setup than `kubernetes/base`.

It demonstrates:
- persistence
- service separation
- health monitoring
- basic container security hardening
- controlled frontend exposure through NodePort
