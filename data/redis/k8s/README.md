# Redis Layer

This folder contains the Kubernetes manifests for the Redis service used by the Voting App.

## Files

### `redis-deployment.yaml`
Creates the Redis Deployment.

Main points:
- Runs 1 Redis pod
- Uses image `redis:alpine`
- Exposes container port `6379`
- Uses readiness and liveness probes on TCP port `6379`
- Applies basic container hardening:
  - `allowPrivilegeEscalation: false`
  - drop all Linux capabilities
  - `seccompProfile: RuntimeDefault`
- Mounts temporary storage at `/data` using `emptyDir`

### `redis-service.yaml`
Creates an internal Kubernetes Service for Redis.

Main points:
- Service name: `redis`
- Type: `ClusterIP`
- Exposes port `6379`
- Selects pods with label `app: redis`

## Role in the application

Redis is used as a fast in-memory layer between the voting app and the worker.

Application flow:
- Vote app sends votes to Redis
- Worker reads votes from Redis
- Worker stores processed results in PostgreSQL

Flow:
`Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Notes

- Redis storage here uses `emptyDir`, which is temporary
- Data stored in Redis will not survive pod deletion
- This is acceptable here because Redis is used as a temporary processing layer, not the final database
