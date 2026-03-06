# Data Layer

Services:
- Redis: queue/buffer for votes
- PostgreSQL: database for results (persistent)

Notes:
- PostgreSQL uses PV/PVC in Kubernetes to keep data after pod restarts.
