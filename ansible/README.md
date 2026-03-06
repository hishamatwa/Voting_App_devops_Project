
# Ansible Automation

This folder contains Ansible playbooks that automate deploying the Voting App to Kubernetes using `kubectl`.
Ansible runs on **localhost** and executes `kubectl` commands for you (deploy + verify + cleanup).

---

## Main playbooks 
1) `ansible/playbooks/deploy_env.yml`
- Deploys the app using `env=dev` or `env=prod`
- Creates namespace
- Applies PV (if exists)
- Applies all manifests
- Waits for pods to become Ready
- Verifies endpoints using curl (vote/result)

2) `ansible/playbooks/cleanup.yml`
- Deletes resources and resets the environment (namespace + policies + pvc + secrets)

---

## Important variables you must understand (deploy_env.yml)

### k8s_ns
Namespace where the app will be deployed (example: `voting`).

### env
Chooses the environment folder:
- `env=dev`  -> manifests in `kubernetes/dev`
- `env=prod` -> manifests in `kubernetes/prod`

### node_ip
Node IP used for NodePort checks:
- vote   -> `http://<node_ip>:31000`
- result -> `http://<node_ip>:31001`

### project_root and manifests_dir (why the path is logical)

You will see:
```yaml
project_root: "{{ playbook_dir }}/../.."
manifests_dir: "{{ project_root }}/kubernetes/{{ env }}"
```

Meaning:
- `playbook_dir` is where the playbook lives: `ansible/playbooks`
- `../..` goes up two directories to the project root
- then we add `/kubernetes/{{ env }}`

So:
- env=dev  -> `<project_root>/kubernetes/dev`
- env=prod -> `<project_root>/kubernetes/prod`

This makes the playbook portable (works even if you move the repo).

---

## What deploy_env.yml does (task-by-task)
1) Show env: prints env and manifests directory  
2) Create namespace: creates `voting` (ignores if exists)  
3) Apply PV if exists: PV is cluster-scoped  
4) Apply manifests: `kubectl apply -n voting -f <manifests_dir>`  
5) Wait Ready: waits until pods are ready  
6) Verify endpoints: curl NodePorts 31000/31001

---

## How to run
DEV:
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=dev -e node_ip=172.18.0.2
```

PROD:
```bash
ansible-playbook -i localhost, ansible/playbooks/deploy_env.yml -e env=prod -e node_ip=172.18.0.2
```

Cleanup:
```bash
ansible-playbook -i localhost, ansible/playbooks/cleanup.yml
```

---

## Common error
If you see: `the path ... does not exist`
Then `manifests_dir` points to the wrong folder.
Fix it to:
```yaml
manifests_dir: "{{ project_root }}/kubernetes/{{ env }}"
```
