# Ansible Automation

This folder contains the **Ansible configuration used to automate deployment and cleanup of the Voting Application on Kubernetes**.

Ansible runs locally and executes `kubectl` commands to deploy and manage the application.

---

# Folder Structure

```
ansible/
├── inventory.ini
├── README.md
├── playbooks/
│   ├── deploy.yml
│   └── cleanup.yml
└── vars/
    ├── dev.yml
    └── prod.yml
```

---

# Inventory

File:

```
inventory.ini
```

This inventory allows Ansible to run locally.

Example:

```ini
[local]
localhost ansible_connection=local
```

---

# Variables

Variables are separated by environment.

## Development Environment

File:

```
vars/dev.yml
```

Example:

```yaml
env: dev
namespace: voting
node_ip: 172.18.0.2
```

---

## Production Environment

File:

```
vars/prod.yml
```

Example:

```yaml
env: prod
namespace: voting
node_ip: 172.18.0.2
```

These variables determine which Kubernetes manifests will be deployed.

---

# Deploy Playbook

File:

```
playbooks/deploy.yml
```

This playbook deploys the Voting Application to Kubernetes.

Main tasks performed:

1. Print selected environment
2. Create Kubernetes namespace
3. Check if PostgreSQL PersistentVolume exists
4. Apply the PersistentVolume
5. Apply Kubernetes manifests
6. Wait until all pods become Ready
7. Display running pods and services

---

# Cleanup Playbook

File:

```
playbooks/cleanup.yml
```

This playbook removes the deployed resources.

Cleanup steps include:

- Deleting the namespace
- Removing PVCs
- Removing secrets
- Cleaning deployed resources

---

# How To Deploy

## Deploy Development Environment

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy.yml -e @ansible/vars/dev.yml
```

## Deploy Production Environment

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy.yml -e @ansible/vars/prod.yml
```

---

# How To Cleanup

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbooks/cleanup.yml
```

---

# Accessing the Application

After deployment, the application is exposed using **NodePort services**.

Vote application:

```
http://<node_ip>:31000
```

Result application:

```
http://<node_ip>:31001
```

Example:

```
http://172.18.0.2:31000
http://172.18.0.2:31001
```

---

# Deployment Verification

Verify the deployment using:

```bash
kubectl get pods -n voting
kubectl get svc -n voting
kubectl get pvc -n voting
```

Expected running services:

- vote
- result
- redis
- db
- worker

---

# Notes

- Ansible is used as an **automation layer** for Kubernetes deployment.
- Kubernetes manifests are stored under the `kubernetes/` directory.
- The selected environment determines which manifests folder is applied.
