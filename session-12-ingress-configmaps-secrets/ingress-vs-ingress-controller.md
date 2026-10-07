# Task 4: Ingress vs Ingress Controller

## What is Ingress?

An **Ingress** is a Kubernetes *API object* (YAML) that declares HTTP/HTTPS
routing rules: hostnames, paths, and which Service each rule sends traffic to.
By itself it does **nothing** — it is just desired-state data.

## What is an Ingress Controller?

An **Ingress Controller** is a *running piece of software* (a Pod, e.g.
ingress-nginx, Traefik, HAProxy, AWS ALB controller) that watches Ingress
objects and programs an actual load balancer/reverse proxy to implement them.

## Difference

| | Ingress | Ingress Controller |
| :--- | :--- | :--- |
| Kind | YAML resource (`kind: Ingress`) | Deployed workload (Deployment/DaemonSet) |
| Role | Declares routing rules | Enforces the rules with a real proxy |
| Analogy | The routing table you write | The router that reads the table |
| Many at once? | Many Ingress objects | Usually one controller per cluster (can be several via `ingressClassName`) |

## Why both are required

```text
User ──▶ Ingress Controller (nginx pod, port 80/443)
            reads
              ▼
         Ingress rules (YAML)
              ▼
         Service ──▶ Pods
```

Without a controller the Ingress object sits unused; without Ingress objects
the controller has no rules to enforce.

## Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx          # which controller serves this
  rules:
    - host: app.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-service
                port:
                  number: 80
```

Minikube quickstart:

```bash
minikube addons enable ingress     # installs the ingress-nginx controller
kubectl get pods -n ingress-nginx
kubectl get ingress
curl -H "Host: app.local" http://$(minikube ip)
```
