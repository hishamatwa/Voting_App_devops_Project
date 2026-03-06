# Network Policies

This folder contains the Kubernetes NetworkPolicy manifests for the Voting App.

## Purpose

These policies control which pods are allowed to receive network traffic.

The goal is to:
- deny unnecessary ingress traffic
- allow internal communication between application components
- expose only the required frontend services externally

## Files

### `networkpolicy-default-deny.yaml`
Creates the default deny ingress policy.

Main behavior:
- applies to all pods in the namespace
- denies ingress traffic by default

This means no pod can receive incoming traffic unless another NetworkPolicy explicitly allows it.

### `networkpolicy-allow.yaml`
Defines the allowed ingress rules.

It includes three policies:

#### `allow-internal-namespace`
Allows pods inside the same namespace to communicate with each other.

This is required for normal application communication, such as:
- `vote` to `redis`
- `worker` to `redis`
- `worker` to `db`

#### `allow-external-to-vote`
Allows external traffic to reach pods with label:
- `app: vote`

Allowed:
- TCP port `80`

#### `allow-external-to-result`
Allows external traffic to reach pods with label:
- `app: result`

Allowed:
- TCP port `80`

## Policy Model

The NetworkPolicy design follows this model:

1. deny ingress by default
2. allow internal traffic inside the namespace
3. allow external traffic only to frontend services

This protects internal components like:
- `db`
- `redis`

while still allowing users to access:
- `vote`
- `result`

## Notes

- These policies affect ingress traffic only
- They require a Kubernetes network plugin that supports NetworkPolicy enforcement
- The frontend remains reachable, while internal services stay protected from direct external access
