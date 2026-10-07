# Session 13: Kubernetes Storage, HPA & Probes

## Work

- Task 1 volumes documentation:
  [01-kubernetes-volumes/README.md](01-kubernetes-volumes/README.md)
  (emptyDir, hostPath, PV, PVC, StorageClass, dynamic provisioning; YAMLs in
  `01-volumes/`, `02-persistent-storage/`, `03-storageclass/`)
- Task 2 HPA runbook: [04-hpa/README.md](04-hpa/README.md)
  (manifests `deployment.yaml`/`service.yaml`/`hpa.yaml`; older scripts in `hpa/`)
- Probes examples: `05-probes/`
- Mini project: [mini-project/README.md](mini-project/README.md)
  (namespace + deployment + service + pvc + hpa)

## Local verification

On a temporary local Minikube lab cluster, `04-hpa` was applied and
`hpa-demo` rolled out successfully in its own namespace. HPA metric
collection/scaling was **not** verified — the metrics API was initially
unavailable (`kubectl top` returned "Metrics API not available" right after
enabling metrics-server), so no scaling claims are made. Mini-project
manifests were exercised via dry-run; namespaced children of a dry-run
namespace can't be validated server-side, which is expected.
