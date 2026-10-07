# CoreDNS

## What is CoreDNS?

CoreDNS is the cluster's DNS server — it runs as a Deployment in
`kube-system` (usually 2 replicas behind the `kube-dns` Service) and answers
name lookups for every Pod.

## Why Kubernetes uses CoreDNS

Pod IPs are ephemeral. Kubernetes needs a dynamic, API-aware DNS so workloads
can find each other by **name**. CoreDNS watches the Kubernetes API and serves
records for Services and Pods automatically — no manual zone files.

## How service discovery works

1. A Service is created → gets a stable ClusterIP.
2. CoreDNS (via the `kubernetes` plugin) publishes
   `svc.ns.svc.cluster.local → ClusterIP`.
3. A Pod resolves the name, connects to the ClusterIP.
4. kube-proxy DNATs the traffic to a healthy endpoint Pod.

## How a DNS query is resolved

```text
Pod ──query──▶ /etc/resolv.conf ──▶ kube-dns Service IP (e.g. 10.96.0.10)
        ──▶ CoreDNS Pod ──▶ plugins chain:
            kubernetes plugin → cluster names (svc/pod)
            forward plugin    → external names (upstream DNS)
            cache plugin      → cached answers
```

## CoreDNS configuration

Lives in the `coredns` ConfigMap in `kube-system`:

```bash
kubectl -n kube-system get configmap coredns -o yaml
```

Typical Corefile:

```text
.:53 {
    errors
    health
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
```

## Troubleshooting DNS issues

```bash
# CoreDNS pods healthy?
kubectl -n kube-system get pods -l k8s-app=kube-dns
kubectl -n kube-system logs -l k8s-app=kube-dns

# Test resolution from a debug pod
kubectl run dnstest --image=busybox:1.36 --restart=Never -- sleep 3600
kubectl exec dnstest -- nslookup kubernetes.default
kubectl exec dnstest -- nslookup my-service.my-namespace.svc.cluster.local

# Check the pod's resolver config and the endpoints
kubectl exec dnstest -- cat /etc/resolv.conf
kubectl get endpoints <service>          # empty => nothing to resolve to
kubectl get svc kube-dns -n kube-system
```

Common causes: wrong Service name/namespace, empty endpoints (selector/label
mismatch), CoreDNS pods crashing, or a broken `forward` for external names.
