# Session 13 — Task 2: HPA Verification Runbook

Uses `deployment.yaml`, `service.yaml` and `hpa.yaml` in this folder
(Deployment `hpa-demo`, Service `hpa-demo-service`, HPA `hpa-demo`).
Run on your own cluster and capture the real output.

## 1. Deploy the application

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get deploy,pods,svc
```

## 2. Configure + verify HPA

```bash
kubectl apply -f hpa.yaml
kubectl get hpa
kubectl describe hpa hpa-demo
```

`kubectl top` requires **metrics-server**:

```bash
kubectl top pods        # minikube: `minikube addons enable metrics-server`
```

## 3. Generate load

```bash
kubectl run loadgen --image=busybox:1.36 --restart=Never -- \
  sh -c "while true; do wget -qO- http://hpa-demo-service; done"
# or use ../hpa/load_generator.sh against the service URL
```

> ⚠️ **CPU-scaling caveat:** the HPA targets CPU utilization, and plain HTTP
> requests to a static nginx page may not create enough CPU load to trigger
> scaling. If `kubectl get hpa` shows utilization stuck near 0%, generate CPU
> load instead — keep it under your control so it can't run forever:
>
> ```bash
> # foreground CPU burn — stop it yourself with Ctrl-C (or close the exec):
> kubectl exec -it deploy/hpa-demo -- sh -c 'while :; do :; done'
> ```
>
> Run it in the foreground so Ctrl-C kills only this workload — do **not**
> background it or use pattern-kills like `pkill -f while` (they can hit
> unrelated processes, and `timeout` isn't guaranteed to exist in the image).
> Alternatively use an app that does real computation per request.
>
> Note: whether the HPA actually scales depends on the load reaching the CPU
> metric threshold — watch `kubectl get hpa` for the real TARGETS value.

## 4. Observe scaling

```bash
watch kubectl get hpa           # TARGETS cpu% climbs, REPLICAS grows
kubectl get pods                # new pods appear
kubectl top pods
kubectl describe hpa hpa-demo   # ScalingActive events
```

## 5. Scale back down

Delete the load generator and watch `kubectl get hpa` — replicas return to
`minReplicas` after the cooldown (~5 min default).

## Evidence table

| Step | Command | My output |
| :--- | :--- | :--- |
| HPA created | `kubectl get hpa` | |
| Load applied | `kubectl top pods` | |
| Scaled up | `kubectl get hpa` / `kubectl get pods` | |
| Scaled down | `kubectl get hpa` | |

Paste your actual output — do not copy expected results.
