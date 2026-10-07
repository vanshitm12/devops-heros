# Mini Project — My Answers

Answers to the questions in `README.md` (original exercise file kept
unanswered on purpose). The answers below are reasoned from the manifests in
this folder — run the commands on your own cluster and fill in the observed
output before submitting.

## Section 7: Broken Pod questions

**Q1: What is the Pod status?**
Expected: `ImagePullBackOff` (it may first show `ErrImagePull`, then settle
into `ImagePullBackOff`).

**Q2: What is the actual error?**
Expected: the image `nginx:this-tag-does-not-exist` cannot be pulled — the tag
does not exist on Docker Hub (`Failed to pull image ... not found`).

**Q3: Which command helped you find the reason?**
`kubectl describe pod project-broken-pod` — the Events section shows
`Failed to pull image` / `ErrImagePull` / `Back-off pulling image`.

**Q4: What is wrong with the image?**
`broken-pod.yaml` sets `image: nginx:this-tag-does-not-exist` — a tag that
doesn't exist.

**Q5: How would you fix it?**
A bare Pod's `image` field is **immutable** — `kubectl apply` on the same Pod
is rejected (`spec: Forbidden: pod updates may not change fields other than
...`). Fix `broken-pod.yaml` to a valid tag (e.g. `nginx:1.27`), then either
`kubectl delete pod project-broken-pod` and `kubectl apply -f broken-pod.yaml`
to recreate it, or create the fixed Pod under a different name.

## Section 11: Troubleshooting table

Fill in the *What I Saw* / *Command I Used* columns with your own output; the
root cause and fix are reasoned from the manifests.

| Problem | What I Saw | Command I Used | Root Cause | Fix |
| :--- | :--- | :--- | :--- | :--- |
| **Broken Pod** | `<fill in>` | `kubectl describe pod project-broken-pod` | Image tag `this-tag-does-not-exist` invalid | Correct tag + delete/recreate the Pod |
| **Service Problem** | `<fill in>` | `kubectl get endpoints troubleshooting-service`, `kubectl get pods --show-labels` | Service selector `wrong-app` ≠ Pod label `troubleshooting-app` | Restore selector to `app: troubleshooting-app` and `kubectl apply -f service.yaml` (Service selector is updatable) |
| **Image Problem** | `<fill in>` | `kubectl describe pod` Events | Nonexistent tag in `spec.containers[].image` | Correct tag + recreate |

## Section 12: README questions

1. **`kubectl get`** shows a summary list/table of resources — names, status,
   age. It's the "what exists and what state is it in" command.
2. **`get` vs `describe`:** `get` lists many objects briefly; `describe`
   shows one object's full detail — spec, status, conditions, and most
   importantly **Events**, which usually reveal the root cause.
3. **`kubectl logs`** reads a container's stdout/stderr — needed when the app
   itself crashes or misbehaves even though the Pod object looks fine.
4. **`kubectl exec`** runs a command inside a running container — for
   interactive checks (`env`, `curl localhost`, `nslookup`, reading config).
5. **CrashLoopBackOff:** the container starts, exits/crashes, Kubernetes
   restarts it, and it keeps crashing with an exponential back-off. Almost
   always an app-level problem — check `kubectl logs`.
6. **ImagePullBackOff:** Kubernetes cannot pull the container image (bad
   name/tag, private registry without credentials) and retries with back-off.
7. **Pending:** no node can run the Pod yet — insufficient CPU/memory, no
   node matches selectors/taints, or an unbound PVC. `describe` shows why.
8. **No endpoints:** the Service selector matches zero Pods — label/selector
   mismatch, or matching Pods aren't `Ready`.
9. **Service selector ↔ Pod labels:** the selector is a label query; only
   Pods whose labels match appear in the Service's Endpoints and receive
   traffic.
10. **Kubernetes DNS:** an internal DNS service (CoreDNS) that gives every
    Service a stable name (`svc.ns.svc.cluster.local`) so Pods can reach it
    without knowing its IP.
