# PostgreSQL Layer

This folder contains the Kubernetes manifests for the PostgreSQL database used by the Voting App.

## Role

PostgreSQL is the persistent database in the application.

It is responsible for:
- Storing the final processed vote results
- Keeping data available even if the PostgreSQL pod restarts
- Serving the result data to other application components

Application flow:
`Vote -> Redis -> Worker -> PostgreSQL -> Result`

---

## Files

### `postgres-deployment.yaml`
Creates the PostgreSQL Deployment.

Main points:
- Runs 1 PostgreSQL pod
- Uses image `postgres:15-alpine`
- Exposes container port `5432`
- Sets the database user with environment variables
- Reads the database password from a Kubernetes Secret
- Uses readiness and liveness probes with `pg_isready`
- Mounts persistent storage at:
  `/var/lib/postgresql/data`

### `postgres-service.yaml`
Creates the internal Kubernetes Service for PostgreSQL.

Main points:
- Service name: `db`
- Type: `ClusterIP`
- Exposes port `5432`
- Selects pods with label `app: db`

This allows other services inside the cluster to connect to PostgreSQL using the stable service name `db`.

### `postgres-secret.yaml`
Stores sensitive database values.

Main points:
- Creates a Secret named `db-secret`
- Stores `POSTGRES_PASSWORD`
- Keeps the password separate from the Deployment manifest

### `postgres-pv.yaml`
Creates the PersistentVolume (PV).

Main points:
- Provides `1Gi` of storage
- Uses access mode `ReadWriteOnce`
- Uses reclaim policy `Retain`
- Uses `hostPath` storage on the node:
  `/data/postgres`

This is the actual storage used to keep PostgreSQL data.

### `postgres-pvc.yaml`
Creates the PersistentVolumeClaim (PVC).

Main points:
- Requests `1Gi` of storage
- Uses access mode `ReadWriteOnce`
- Binds to the PersistentVolume `postgres-pv`

This is the storage request used by the PostgreSQL pod.

---

## Storage Design

PostgreSQL uses persistent storage so the database data is not lost when the pod restarts.

Storage flow:
- `PersistentVolume (PV)` provides the real storage
- `PersistentVolumeClaim (PVC)` requests that storage
- The Deployment mounts the PVC into the PostgreSQL container

Mount path inside the container:
`/var/lib/postgresql/data`

This path is where PostgreSQL stores its database files.

---

## Health Checks

The PostgreSQL container uses:

### Readiness Probe
Checks whether PostgreSQL is ready to accept connections.

Command used:
`pg_isready -U postgres`

### Liveness Probe
Checks whether PostgreSQL is still running correctly.

Command used:
`pg_isready -U postgres`

This helps Kubernetes know:
- when the database is ready
- when the container needs to be restarted

---

## Network Access

PostgreSQL is exposed internally using a `ClusterIP` Service.

This means:
- it is reachable only from inside the Kubernetes cluster
- it is not exposed directly outside the cluster

Other application components can connect to PostgreSQL using:
- Service name: `db`
- Port: `5432`

---

## Notes

- PostgreSQL is the final persistent data store in this project
- Redis is used only as a temporary fast layer
- The worker reads votes from Redis and writes final results into PostgreSQL
- The password is stored in a Kubernetes Secret, not directly in the Deployment
- The PV uses `hostPath`, which is suitable for local labs and small environments
