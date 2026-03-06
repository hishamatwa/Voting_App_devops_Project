# Kubernetes Base Manifests

This folder contains the base Kubernetes manifests for the Voting App.

## Purpose

The `base` folder provides a minimal reference version of the application manifests.

It is intended for:
- learning the basic Kubernetes structure
- understanding how Deployments and Services work
- serving as a simple starting point before adding more advanced features

## What is included

This folder contains the core application components:

- PostgreSQL Deployment and Service
- Redis Deployment and Service
- Vote Deployment and Service
- Result Deployment and Service
- Worker Deployment

## Characteristics of this folder

The manifests in `kubernetes/base` are intentionally simple.

They include:
- basic Deployments
- basic Services
- minimal configuration

They do **not** include most of the advanced improvements found in the main demo environment, such as:
- readiness and liveness probes
- Secret-based database password management
- PersistentVolume (PV) and PersistentVolumeClaim (PVC) for PostgreSQL
- container security hardening
- environment-specific structure

## Service exposure

- `vote` is exposed externally on port `31000`
- `result` is exposed externally on port `31001`

Internal data services:
- `db` uses `ClusterIP`
- `redis` uses `ClusterIP`

## Storage behavior

### PostgreSQL
In this base folder, PostgreSQL uses `emptyDir` storage.

This means:
- storage is temporary
- database data is tied to the pod lifecycle
- data will be lost if the PostgreSQL pod is deleted

### Redis
Redis also uses `emptyDir`, which is acceptable here because Redis acts as a temporary in-memory layer.

## Application flow

`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

## Important note

This folder is mainly for learning and reference.

It is **not** the main recommended demo environment.

For the local demo and the improved manifests, use:

- `kubernetes/dev`

That folder includes a more complete setup with better structure, persistence, health checks, and security settings.
