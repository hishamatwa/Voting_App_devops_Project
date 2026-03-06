# Data Layer

This folder contains the Kubernetes manifests for the data services used by the Voting App.

## Components

### PostgreSQL
Used as the persistent database for final vote results.

Files:
- `postgres-deployment.yaml`
- `postgres-service.yaml`
- `postgres-secret.yaml`
- `postgres-pv.yaml`
- `postgres-pvc.yaml`

Main role:
- Stores final processed results permanently

### Redis
Used as a fast temporary data layer between the vote app and the worker.

Files:
- `redis-deployment.yaml`
- `redis-service.yaml`

Main role:
- Receives votes quickly
- Makes them available for the worker to process

## Application flow

`Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Storage design

### PostgreSQL storage
PostgreSQL uses persistent storage:
- `PersistentVolume (PV)` provides the actual storage
- `PersistentVolumeClaim (PVC)` requests and binds that storage
- Data is mounted into PostgreSQL at `/var/lib/postgresql/data`

This allows database data to survive container restarts.

### Redis storage
Redis uses:
- `emptyDir`

This is temporary storage tied to the pod lifecycle.
If the Redis pod is deleted, its stored data is lost.

## Network access

Both PostgreSQL and Redis are exposed internally using `ClusterIP` Services:
- PostgreSQL service name: `db`
- Redis service name: `redis`

This allows other application components inside the cluster to connect using stable service names.

## Security notes

PostgreSQL password is stored in a Kubernetes Secret.
Redis container includes basic security hardening:
- no privilege escalation
- all extra Linux capabilities dropped
- default seccomp profile
