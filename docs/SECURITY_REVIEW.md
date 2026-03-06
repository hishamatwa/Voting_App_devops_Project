# Security Review

This document summarizes the main security measures applied in the project and highlights the current limitations.

## Security Controls Already Applied

### 1. Container hardening
Several workloads use container security settings such as:
- `allowPrivilegeEscalation: false`
- dropping unnecessary Linux capabilities
- `seccompProfile: RuntimeDefault`

This reduces the attack surface and prevents containers from running with unnecessary privileges.

### 2. Minimal capability usage
Frontend containers drop all capabilities and add back only:
- `NET_BIND_SERVICE`

This is required because the applications listen on port `80`, while still keeping privilege usage limited.

### 3. Secret usage for database password
The PostgreSQL password is stored in a Kubernetes **Secret** instead of being written directly in the Deployment manifest.

This improves separation of sensitive configuration from application runtime definitions.

### 4. Health checks
The services use **readiness** and **liveness** probes.

These help Kubernetes:
- route traffic only to healthy and ready containers
- restart containers that stop responding correctly

### 5. Internal-only data services
Redis and PostgreSQL are exposed using **ClusterIP** services.

This means they are not directly exposed outside the Kubernetes cluster.

## Current Limitations

### 1. Demo-level secret management
The current database password is still stored in a YAML Secret manifest in the repository structure.

For a stronger production setup, secrets should be managed using:
- external secret managers
- encrypted secret storage
- CI/CD secret injection

### 2. Use of `latest` image tags
Some application images use the `latest` tag.

This is not ideal for production because deployments become less predictable.
Version-pinned image tags are recommended.

### 3. Single replica design
Most services run with:
- `replicas: 1`

This is acceptable for a demo or lab environment, but it limits availability and fault tolerance.

### 4. Local storage approach
PostgreSQL uses:
- `hostPath`

This is suitable for local testing and small environments, but not ideal for production-grade persistent storage.

### 5. Redis uses temporary storage
Redis uses:
- `emptyDir`

This means Redis data is lost if the pod is deleted.
That is acceptable in this project because Redis is used only as a temporary layer, not the final system of record.

### 6. No advanced network isolation shown
The current manifests do not show advanced controls such as:
- `NetworkPolicy`
- pod security admission policies
- ingress-level filtering
- mTLS between services

These would strengthen a production deployment.

## Overall Assessment

The project applies several good baseline Kubernetes security practices:
- reduced privileges
- controlled capabilities
- runtime default seccomp
- secret separation
- health probes
- internal-only data services

Overall, the security posture is appropriate for:
- academic review
- local lab use
- small demo deployment

For production use, the next improvements should focus on:
- stronger secret management
- pinned image versions
- better storage backends
- multi-replica high availability
- network policy enforcement
