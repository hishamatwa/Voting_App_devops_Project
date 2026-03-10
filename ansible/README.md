# Ansible Automation

This folder contains the Ansible configuration used to automate deployment and cleanup of the Voting Application on Kubernetes.

Ansible runs locally and executes `kubectl` commands to deploy the application infrastructure and services.

---

# Folder Structure


ansible/
│
├── inventory.ini
├── README.md
│
├── playbooks/
│ ├── deploy.yml
│ └── cleanup.yml
│
└── vars/
├── dev.yml
└── prod.yml


---

# Inventory


inventory.ini


This inventory runs Ansible locally.

Example:

```ini
[local]
localhost ansible_connection=local
Variables

Variables are separated by environment.

Development Environment
vars/dev.yml

Example values:

env: dev
namespace: voting
node_ip: 172.18.0.2
Production Environment
vars/prod.yml

Example values:

env: prod
namespace: voting
node_ip: 172.18.0.2

These variables determine which Kubernetes manifests will be deployed.

Deploy Playbook
playbooks/deploy.yml

This playbook deploys the Voting Application to Kubernetes.

Main tasks performed:

Print selected environment

Create Kubernetes namespace

Check if PostgreSQL PersistentVolume exists

Apply the PersistentVolume

Apply Kubernetes manifests

Wait until all pods become Ready

Display running pods and services

Cleanup Playbook
playbooks/cleanup.yml

This playbook removes the deployed resources.

Cleanup steps include:

deleting the namespace

removing PVCs

removing secrets

cleaning deployed resources

How To Deploy

Run deployment using the desired environment variables file.

Deploy Development Environment
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy.yml -e @ansible/vars/dev.yml
Deploy Production Environment
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy.yml -e @ansible/vars/prod.yml
How To Cleanup
ansible-playbook -i ansible/inventory.ini ansible/playbooks/cleanup.yml
Accessing the Application

After deployment, the services will be available using NodePort.

Vote application:

http://<node_ip>:31000

Result application:

http://<node_ip>:31001

Example:

http://172.18.0.2:31000
http://172.18.0.2:31001
Deployment Verification

You can verify the deployment using:

kubectl get pods -n voting
kubectl get svc -n voting
kubectl get pvc -n voting

Expected running services:

vote

result

redis

db

worker

Notes

Ansible is used as an automation layer for Kubernetes deployment.

Kubernetes manifests are stored under the kubernetes/ directory.

Environment selection determines which manifests folder is applied.
