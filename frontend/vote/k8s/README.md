# Vote Service

This folder contains the Kubernetes manifests for the `vote` frontend service of the Voting App.

## Role

The `vote` service is the user-facing application where users submit their votes.

It is the main entry point for voting in the application.

Application flow:
`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Files

### `vote-deployment.yaml`
Creates the Deployment for the vote application.

Main points:
- Runs 1 replica
- Uses image `nexusameer/voting-app-vote:latest`
- Exposes container port `80`
- Uses HTTP readiness and liveness probes on `/`
- Applies container security hardening
- Adds only `NET_BIND_SERVICE` so the app can bind to port `80`

### `vote-service.yaml`
Creates the Service for the vote application.

Main points:
- Service name: `vote`
- Type: `NodePort`
- Service port: `8080`
- Container target port: `80`
- External NodePort: `31000`

Access:
`http://<node_ip>:31000`

## Notes

- The `vote` service is exposed externally through NodePort
- It is intended for end users to submit votes
- The service selects pods with label `app: vote`
