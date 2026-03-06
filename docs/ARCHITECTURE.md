# Architecture

This project is a containerized cloud-native voting application deployed on Kubernetes.

## High-Level Structure

The system is divided into three main layers:

### Frontend
- **vote** (Python): user-facing service where users submit votes
- **result** (NodeJS): user-facing service where users view voting results

### Backend
- **worker** (.NET): background service that reads votes from Redis and stores processed results in PostgreSQL

### Data
- **redis**: temporary in-memory data layer used to receive votes quickly
- **postgres**: persistent database used to store final processed vote results

## End-to-End Flow

`User -> Vote -> Redis -> Worker -> PostgreSQL -> Result`

### Flow explanation
1. The user submits a vote using the **vote** frontend service.
2. The vote is sent to **Redis**, which acts as a fast temporary store.
3. The **worker** service reads votes from Redis.
4. The worker writes the processed results into **PostgreSQL**.
5. The **result** frontend service reads and displays the final results.

## Kubernetes Design

### Frontend exposure
The frontend services are exposed externally using **NodePort**:
- **vote** -> `31000`
- **result** -> `31001`

This allows users to access the application from outside the cluster using the node IP.

### Internal services
The data services are exposed internally using **ClusterIP**:
- **redis**
- **db** (PostgreSQL)

This keeps internal data components reachable only from inside the cluster.

## Storage Design

### PostgreSQL
PostgreSQL uses persistent storage:
- **PersistentVolume (PV)** provides the actual storage
- **PersistentVolumeClaim (PVC)** requests that storage for the database pod

This ensures database data is not lost when the PostgreSQL pod restarts.

### Redis
Redis uses **emptyDir** storage.
This is temporary storage attached to the pod lifecycle and is acceptable here because Redis is used only as a temporary processing layer, not the final database.

## Summary

The architecture separates responsibilities clearly:
- frontend handles user interaction
- backend processes votes
- data layer stores temporary and final data

This design keeps the application simple, modular, and easy to explain during review.
