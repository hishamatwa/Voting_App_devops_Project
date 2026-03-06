# Result Service

This folder contains the Kubernetes manifests for the `result` frontend service of the Voting App.

## Role

The `result` service is the user-facing application that displays the voting results.

It reads the processed results from the backend data flow and presents them to the user.

Application flow:
`Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Files

### `result-deployment.yaml`
Creates the Deployment for the result application.

Main points:
- Runs 1 replica
- Uses image `nexusameer/voting-app-result:latest`
- Exposes container port `80`
- Uses HTTP readiness and liveness probes on `/`
- Applies container security hardening
- Adds only `NET_BIND_SERVICE` so the app can bind to port `80`

### `result-service.yaml`
Creates the Service for the result application.

Main points:
- Service name: `result`
- Type: `NodePort`
- Service port: `8081`
- Container target port: `80`
- External NodePort: `31001`

Access:
`http://<node_ip>:31001`

## Notes

- The `result` service is exposed externally through NodePort
- It is intended for end users to view the current voting results
- The service selects pods with label `app: result`
