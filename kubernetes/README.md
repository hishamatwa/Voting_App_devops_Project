# Kubernetes Manifests

This folder contains Kubernetes YAML manifests for the Voting App.

Structure:
- apps/voting/base : reference manifests
- apps/voting/dev  : tuned for local kind (single-node)
- apps/voting/prod : production-ish manifests (may need more cluster resources)

DEV is used for local demo.
PROD is used to show production concepts (resources/limits, stricter policies).
