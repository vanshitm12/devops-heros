# Session 11: Kubernetes Networking & Services

## Service demos (one folder per type)

- [01-clusterip/README.md](01-clusterip/README.md)
- [02-nodeport/README.md](02-nodeport/README.md)
- [03-loadbalancer/README.md](03-loadbalancer/README.md)
- [04-externalname/README.md](04-externalname/README.md)
- [05-headless/README.md](05-headless/README.md)

## Task 2: Object comparison

- [object-comparison.md](object-comparison.md) — Deployment vs ReplicaSet,
  Deployment vs DaemonSet vs StatefulSet, ReplicaSet vs Service.

## Tasks 3 & 4: DNS

- [fqdn/README.md](fqdn/README.md) — Kubernetes FQDN, `svc.ns.svc.cluster.local` naming.
- [coredns/README.md](coredns/README.md) — CoreDNS architecture + troubleshooting.
- (Older combined notes: [fqdn.md](fqdn.md), [service.md](service.md))

## Local verification

On a temporary local Minikube lab cluster, the ClusterIP demo was applied and
a client Pod reached `web-service-clusterip:8080` with `HTTP 200`; `nslookup`
resolved `web-service-clusterip.<ns>.svc.cluster.local` to its ClusterIP. The
other Service types were documented but not exercised live.
