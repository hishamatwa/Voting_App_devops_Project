# Security

Implemented security controls:
- Kubernetes Secret for DB password (db-secret)
- NetworkPolicies:
  - default deny ingress
  - allow internal namespace traffic
  - allow external access ONLY to vote/result
- Container hardening (SecurityContext):
  - allowPrivilegeEscalation: false
  - drop Linux capabilities
  - add NET_BIND_SERVICE only where needed (vote/result bind port 80)
  - seccompProfile: RuntimeDefault
