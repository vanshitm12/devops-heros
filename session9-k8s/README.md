# Resources

- https://kubernetes.io/docs/tutorials/kubernetes-basics/
- https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download 

- https://kubernetes.io/docs/concepts/architecture/

- https://github.com/Nency-Ravaliya/Kubernetes

# Hands-on: Cluster Setup, Architecture & Core Objects

> These are the commands to run on your own machine once Minikube is
> installed. Run them yourself and paste your own output as evidence.

## 1. Install and start Minikube

```bash
# macOS (arm64)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
sudo install minikube-darwin-arm64 /usr/local/bin/minikube

minikube start --driver=docker
```

## 2. Verify cluster status

```bash
minikube status
kubectl cluster-info
kubectl get nodes
kubectl version
```

## 3. Kubernetes architecture — short notes

```text
                 Control Plane (master)
 ┌──────────────────────────────────────────────┐
 │ kube-apiserver   – front door, all traffic   │
 │ etcd             – cluster state (key-value) │
 │ kube-scheduler   – picks a node for each Pod │
 │ controller-mgr   – keeps desired state       │
 └──────────────────────────────────────────────┘
                 Worker Nodes
 ┌──────────────────────────────────────────────┐
 │ kubelet     – runs Pods on the node          │
 │ kube-proxy  – networking / Service rules     │
 │ container runtime (containerd/docker)        │
 └──────────────────────────────────────────────┘
```

`kubectl` talks to the **API server**; the scheduler places Pods; kubelets run
them; etcd stores everything.

## 4. Core objects & commands

| Object | What it is | Commands |
| :--- | :--- | :--- |
| Pod | Smallest deployable unit (1+ containers) | `kubectl get pods`, `kubectl describe pod`, `kubectl logs` |
| ReplicaSet | Keeps N identical Pods running | `kubectl get rs` |
| Deployment | Manages ReplicaSets + rollouts | `kubectl get deploy`, `kubectl rollout status` |
| Service | Stable IP/DNS in front of Pods | `kubectl get svc`, `kubectl describe svc` |
| Namespace | Logical cluster partition | `kubectl get ns` |

## 5. Kubernetes Basics tutorial (hands-on)

```bash
kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
kubectl get deployments
kubectl get pods
kubectl expose deployment hello-node --type=NodePort --port=8080
kubectl get services
minikube service hello-node        # opens the app in a browser
kubectl scale deployment hello-node --replicas=4
kubectl get pods -o wide
kubectl delete service hello-node
kubectl delete deployment hello-node
```

Record your own command output/screenshots for the deliverables.

## Submission index

- Minikube install + cluster verification commands
- Kubernetes architecture notes (control plane vs worker nodes)
- Core objects & commands (Pod, ReplicaSet, Deployment, Service, Namespace)
- Kubernetes Basics tutorial steps (`create deployment`, `expose`, `scale`, `service`)

## Status

Instructions only — a local lab cluster was used for other sessions'
verification; the Session 9 tutorial steps themselves were not re-executed.
Paste your own `minikube status` / `kubectl` output as evidence.
