- https://github.com/Nency-Ravaliya/Kubernetes 

- k8s core objects: https://github.com/Nency-Ravaliya/Kubernetes/blob/main/core-objects.md

## Submission index

- Deployment strategies:
  [01-rolling-update/README.md](01-rolling-update/README.md),
  [02-blue-green/README.md](02-blue-green/README.md),
  [03-canary/README.md](03-canary/README.md),
  [04-recreate/README.md](04-recreate/README.md)
- Pod lifecycle: [pod-lifecycle/README.md](pod-lifecycle/README.md)
- Core-object YAMLs: [pod.yml](pod.yml), [replicaset.yml](replicaset.yml),
  [deployment.yml](deployment.yml), [service.yml](service.yml),
  [daemonset/node-agent-ds.yaml](daemonset/node-agent-ds.yaml),
  `pod/`, `replicaset/`, `deployment/`, `k8s-core-objects/`, `troubleshooting/`

## Status

Rolling update was verified on a temporary local Minikube lab cluster:
v1 (nginx:1.24-alpine) rolled to v2 (nginx:1.25-alpine), rollout history
recorded 2 revisions, old ReplicaSet pods terminated. Other strategies are
documented but not live-executed.
