
# kubernetes/prod (Production-ish)

Purpose:
- Shows production-style concepts and stricter configs.
- Might need more CPU/memory than local kind.

Recommended production improvements (optional):
- Add the same NetworkPolicies as dev
- Add resource requests/limits
- Run containers as non-root (if apps bind to non-privileged ports like 8080)

Note:
- For interviews/demos, `dev` is the environment that is guaranteed to run locally.
