<<<<<<< HEAD
# Voting App – End-to-End Kubernetes Deployment + Automation (Linux/Docker/K8s/Ansible)

This repo provides an end-to-end example of running and automating a microservices voting application using ONLY:
- Linux
- Docker
- Kubernetes (kubectl)
- Ansible

Goal: show a production-style Kubernetes deployment (as much as possible on local cluster), with automation and a security review.

---

## 1) What is this project?

A classic microservices voting application:

### Services
- Front-End
  - vote   : Voting UI
  - result : Results UI
- Back-End
  - worker : Reads votes from Redis and writes results to Postgres
- Data Layer
  - redis  : Queue / buffer
  - db (postgres) : Database (persistent)

### Data Flow
User -> vote -> redis -> worker -> postgres -> result

---

## 2) What I implemented 

✅ Kubernetes deployment (Working)
- Deployments: vote, result, worker, redis, db
- Services:
  - vote   NodePort 31000
  - result NodePort 31001
  - db and redis are ClusterIP (internal only)

✅ Persistence
- Postgres uses PV/PVC so data is persistent

✅ Secrets
- Postgres password stored in Secret (db-secret)

✅ Health checks
- DB: pg_isready readiness/liveness
- vote/result: HTTP GET / readiness/liveness
- redis: TCP socket readiness/liveness

✅ Security review / hardening
- NetworkPolicies:
  - default deny ingress
  - allow internal namespace traffic
  - allow external ONLY to vote/result
- SecurityContext:
  - allowPrivilegeEscalation: false
  - drop linux capabilities
  - add NET_BIND_SERVICE for vote/result (needed for port 80)
  - seccomp RuntimeDefault

✅ Automation (Ansible)
- deploy_env.yml : deploy + verify (dev/prod)
- cleanup.yml    : delete everything

---

## 3) Repository Structure

```
kubernetes/
  apps/
    voting/
      base/   # original demo manifests (reference)
      dev/    # local kind (single-node) tuned to work locally
      prod/   # production-ish (may need more cluster resources)
ansible/
  playbooks/
    deploy_env.yml
    cleanup.yml
README.md
```

Why dev/ and prod/?
- dev/ is tuned for local single-node cluster (kind).
- prod/ is more production-like and may require bigger cluster capacity.

---

## 4) Tools Used (Only)
- Linux commands
- Docker / Docker Compose
- Kubernetes (kubectl)
- Ansible (runs kubectl commands)

No Terraform, no Helm, no ArgoCD/Flux.

---

## 5) Prerequisites
- Docker
- Kubernetes cluster (kind/minikube/any)
- kubectl
- Ansible

Check:
```bash
docker --version
kubectl version --client
ansible --version
```

---

## 6) Run Locally with Docker
From project root:
```bash
docker compose up -d --build
docker compose ps
```

Open:
- http://localhost:8080 (vote)
- http://localhost:8081 (result)

Stop:
```bash
docker compose down
```

---

## 7) Deploy on Kubernetes (DEV) using Ansible

### 7.1 Get your node IP
```bash
kubectl get nodes -o wide
```

For kind, it is often something like: 172.18.0.2 (your value may differ)

### 7.2 Deploy (dev)
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2
```

### 7.3 Access the app
- vote  : http://172.18.0.2:31000
- result: http://172.18.0.2:31001

Quick check:
```bash
curl -I http://172.18.0.2:31000
curl -I http://172.18.0.2:31001
```

### 7.4 Verify
```bash
kubectl get pods -n voting
kubectl get svc -n voting
kubectl get networkpolicy -n voting
```

---

## 8) Deploy on Kubernetes (PROD) using Ansible
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=prod -e node_ip=172.18.0.2
```

Note: prod/ may require a bigger cluster (more CPU/memory).

---

## 9) Cleanup (Remove everything)
```bash
ansible-playbook -i localhost, ansible/playbooks/cleanup.yml
```

---

## 10) Security Notes

NetworkPolicies pattern:
- deny by default
- allow only what is needed

SecurityContext and port 80:
- vote/result bind port 80 inside container
- when dropping all capabilities, binding port 80 fails unless we allow NET_BIND_SERVICE
- we keep security hardening while still allowing the app to work

PodSecurity warnings:
- you may see warnings about runAsNonRoot
- we did not enforce it strictly here because some images bind to port 80 and may break on demo cluster

---

## 11) Troubleshooting

A) Pods stuck in Pending (Insufficient CPU)
```bash
kubectl get events -n voting --sort-by=.lastTimestamp | tail -n 30
```
Use dev/ env on kind:
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2
```

B) vote/result not reachable (Connection refused)
```bash
kubectl get pods -n voting
kubectl get endpoints -n voting vote result
kubectl logs -n voting deploy/vote --tail=80
```

---

## 12) Useful Debug Commands
```bash
kubectl get pods -n voting
kubectl get svc -n voting
kubectl get networkpolicy -n voting
kubectl get events -n voting --sort-by=.lastTimestamp | tail -n 30

kubectl describe pod -n voting -l app=vote
kubectl logs -n voting deploy/vote --tail=80
kubectl logs -n voting deploy/result --tail=80
kubectl logs -n voting deploy/worker --tail=80
kubectl logs -n voting deploy/redis --tail=80
kubectl logs -n voting deploy/db --tail=80
```

---



## 13) Reference
Original reference project:
https://github.com/nexusameer/Voting-App-Microservices
=======
# Voting App - Kubernetes + Docker + Ansible (Easy)

## 1) Architecture (Simple)
Microservices:

- Front-End:
  - **vote**: voting UI
  - **result**: results UI
- Back-End:
  - **worker**: reads votes from redis and writes to postgres
- Data:
  - **redis**: queue
  - **postgres (db)**: database (persistent)

Flow:
User -> vote -> redis -> worker -> postgres -> result

## 2) Folder structure
- `kubernetes/apps/voting/base` : original demo YAML
- `kubernetes/apps/voting/dev`  : works on local kind (no CPU requests)
- `kubernetes/apps/voting/prod` : production-ish (resources + probes)
- `ansible/playbooks`           : automation (deploy/cleanup)

## 3) Run with Docker
```bash
docker compose up -d --build
docker compose ps
>>>>>>> 9063484 (Initial commit: voting app k8s + ansible automation + security)
