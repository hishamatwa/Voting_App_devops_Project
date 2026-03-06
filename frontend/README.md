# Frontend Layer

This folder contains the Kubernetes manifests for the frontend services of the Voting App.

## Services

### vote
The vote service is the user-facing application where users submit their votes.

Main points:
- Runs as a Kubernetes Deployment
- Exposed externally using a NodePort Service
- Container listens on port `80`
- Accessible from outside the cluster on NodePort `31000`

Access:
`http://<node_ip>:31000`

### result
The result service is the user-facing application where users can view the voting results.

Main points:
- Runs as a Kubernetes Deployment
- Exposed externally using a NodePort Service
- Container listens on port `80`
- Accessible from outside the cluster on NodePort `31001`

Access:
`http://<node_ip>:31001`

## Application flow

The frontend layer is the entry point for users.

Flow:
`User -> vote -> Redis -> Worker -> PostgreSQL -> result`

Meaning:
- The user submits a vote through the `vote` service
- Votes are passed through Redis
- The worker processes the votes
- Final results are stored in PostgreSQL
- The `result` service displays the final results

## Health checks

Both frontend services use:
- `readinessProbe` with HTTP GET on `/`
- `livenessProbe` with HTTP GET on `/`

This helps Kubernetes know:
- when the application is ready to receive requests
- when the container should be restarted

## Security

Both frontend containers use basic security hardening:
- `allowPrivilegeEscalation: false`
- drop all Linux capabilities
- add only `NET_BIND_SERVICE`
- `seccompProfile: RuntimeDefault`

`NET_BIND_SERVICE` is required because the applications listen on port `80`.

## Folder structure

- `result/`
  - `result-deployment.yaml`
  - `result-service.yaml`

- `vote/`
  - `vote-deployment.yaml`
  - `vote-service.yaml`
