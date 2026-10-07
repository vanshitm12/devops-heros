# Mini Project — Troubleshooting Runbook

The commands for the two injected failures, with before/after checks. The
"expected" notes below are reasoned from the manifests — run them on your own
cluster and replace the `<paste>` slots with your real output.

## Issue 1: broken-pod.yaml — bad image tag

**Before:**

```bash
kubectl apply -f broken-pod.yaml
kubectl get pod project-broken-pod
# expected: ErrImagePull -> ImagePullBackOff
kubectl describe pod project-broken-pod
# expected Events: Failed to pull image "nginx:this-tag-does-not-exist" ... not found
```

**Root cause:** image tag `this-tag-does-not-exist` does not exist.

**Fix — note on `kubectl apply`:** a bare Pod's container image is immutable;
editing `image:` and running `kubectl apply` on the *same* Pod is rejected
(`spec: Forbidden: pod updates may not change fields other than ...`). Either:

```bash
# option A: fix broken-pod.yaml -> image: nginx:1.27, then delete + recreate
kubectl delete pod project-broken-pod
kubectl apply -f broken-pod.yaml

# option B: create a fixed pod under a different name, e.g.
#   kubectl run project-fixed-pod --image=nginx:1.27
```

**After:**

```bash
kubectl get pod project-broken-pod          # expected: Running 1/1
kubectl port-forward pod/project-broken-pod 8080:80 &
curl -s localhost:8080 | head -5            # expected: nginx welcome HTML
```

(`kubectl exec ... -- curl` is unreliable — the nginx image may not contain
`curl`. `port-forward` + host `curl`, or a busybox pod with `wget`, works.)

## Issue 2: Service selector mismatch

**Before:**

```bash
# edit service.yaml -> selector app: wrong-app, then:
kubectl apply -f service.yaml
kubectl get endpoints troubleshooting-service
# expected: ENDPOINTS   <none>
kubectl get pods --show-labels
# pods carry label app=troubleshooting-app  <- mismatch found
kubectl describe service troubleshooting-service
# Selector: app=wrong-app
```

**Root cause:** Service selector `wrong-app` matches no Pods.

**Fix:** unlike Pod image, a Service's `selector` **is** updatable — restore it
and apply:

```bash
# restore selector -> app: troubleshooting-app in service.yaml
kubectl apply -f service.yaml
```

**After:**

```bash
kubectl get endpoints troubleshooting-service   # expected: the 2 Pod IPs
kubectl run curlpod --image=busybox:1.36 --restart=Never --rm -it -- \
  wget -qO- http://troubleshooting-service      # expected: nginx welcome HTML
```

## Evidence

| Check | Before | After |
| :--- | :--- | :--- |
| `kubectl get pod project-broken-pod` | `<paste>` | `<paste>` |
| `kubectl get endpoints troubleshooting-service` | `<paste>` | `<paste>` |
