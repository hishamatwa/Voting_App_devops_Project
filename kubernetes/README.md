
# Kubernetes Manifests

This folder contains the Kubernetes manifests for the Voting App.

The manifests are organized into multiple environments to support learning, local demos, and more production-style configurations.

## Folder Structure

### `base/`
The minimal reference version of the application manifests.

Purpose:
- simple Kubernetes YAMLs for learning
- basic Deployments and Services only
- useful as a starting point before adding persistence, security, and health checks

Notes:
- PostgreSQL uses temporary storage
- no Secret-based password management
- no health probes
- no container hardening
- mainly intended for reference and study

### `dev/`
The recommended local demo environment.

Purpose:
- designed to run reliably on local kind or single-node Kubernetes clusters
- includes the main improvements needed for a stronger demo setup

Includes:
- PostgreSQL Secret
- PersistentVolume and PersistentVolumeClaim for database storage
- readiness and liveness probes
- container security hardening
- NetworkPolicies
- frontend exposure through NodePort

Access:
- `vote` -> `31000`
- `result` -> `31001`

Notes:
- this is the recommended environment for local testing, demos, and presentations

### `prod/`
A production-style version of the manifests.

Purpose:
- demonstrates a more structured setup than `base`
- includes persistence, Secret-based configuration, health checks, and container hardening

Includes:
- PostgreSQL Secret
- PersistentVolume and PersistentVolumeClaim
- readiness and liveness probes
- container security hardening
- frontend exposure through NodePort

Notes:
- this folder is closer to a production-style layout than `base`
- depending on the environment, it may require more resources than a simple local cluster
- unlike `dev`, it does not currently include the same NetworkPolicy configuration

## Core Application Components

Across the environments, the application is built from these main components:

### Frontend
- `vote`: user submits votes
- `result`: user views results

### Backend
- `worker`: reads votes from Redis and stores processed results in PostgreSQL

### Data
- `redis`: temporary fast data layer
- `db` (PostgreSQL): persistent database for final results

## Application Flow

`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Recommendation

For learning the basic structure:
- use `base/`

For local demos and the most reliable review environment:
- use `dev/`

For a more production-style version of the manifests:
- use `prod/`
