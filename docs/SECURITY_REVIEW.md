Security implemented:
- Secret for DB password (db-secret)
- PV/PVC for PostgreSQL persistence
- Probes (readiness/liveness)
- NetworkPolicies (default deny + allow only needed)
- SecurityContext hardening (no privilege escalation, drop caps, seccomp)
- NET_BIND_SERVICE only for vote/result (bind port 80)
