# FQDN in Kubernetes

## What is FQDN?

A **Fully Qualified Domain Name** is the complete, unambiguous DNS name of a
host or service — e.g. `www.example.com.` In Kubernetes it lets Pods reach a
Service from any namespace without knowing its IP.

## Kubernetes Service DNS

Every Service automatically gets a DNS record in the cluster's DNS server
(CoreDNS). Pods use these names instead of Pod IPs, which change.

## DNS naming convention

```text
<service>.<namespace>.svc.<cluster-domain>

e.g.
backend.default.svc.cluster.local
 └──────┘ └─────┘ └─┘ └────────────┘
 service namespace  svc  cluster domain (default: cluster.local)
```

## Namespace-based DNS

- **Same namespace:** short name works — `curl http://backend`
- **Different namespace:** include the namespace or the full FQDN —
  `backend.other-ns` or `backend.other-ns.svc.cluster.local`
- Pod `/etc/resolv.conf` contains
  `search <ns>.svc.cluster.local svc.cluster.local cluster.local`, which is
  what expands the short names.

## Pod-to-Service communication

```text
Pod A ──DNS query "backend"──▶ CoreDNS ──returns ClusterIP──▶ Pod A
Pod A ──traffic to ClusterIP──▶ kube-proxy ──▶ healthy backend Pod
```

## Examples of Kubernetes FQDNs

| Kind | FQDN pattern | Example |
| :--- | :--- | :--- |
| Service | `svc.ns.svc.cluster.local` | `web.prod.svc.cluster.local` |
| Headless service Pod | `podname.svc.ns.svc.cluster.local` | `db-0.db.prod.svc.cluster.local` |
| Pod (by IP) | `a-b-c-d.ns.pod.cluster.local` | `10-244-1-7.default.pod.cluster.local` — only when CoreDNS `pods` mode serves Pod DNS records (conditional on Corefile config; the `pods insecure` option enables it) |

## Try it

```bash
kubectl run dnstest --image=busybox:1.36 --restart=Never -- sleep 3600
kubectl exec dnstest -- nslookup kubernetes.default.svc.cluster.local
kubectl exec dnstest -- cat /etc/resolv.conf
```
