# Session 12 — Task 5: Troubleshooting Runbook

Steps for the broken examples in this session. Fill in your own observed
output before/after each fix.

## General method

```bash
kubectl get pods
kubectl describe pod <pod>
kubectl logs <pod>
kubectl get events --sort-by=.lastTimestamp
```

## Issue 1: Secret values look wrong inside the Pod

**Symptom:** the app misbehaves as if its env var is wrong — e.g. it received
the literal base64 string instead of the decoded value.

Investigate **without printing secret values**:

```bash
kubectl describe secret db-secret                          # key names + sizes, values NOT printed
kubectl describe pod <pod> | grep -A5 Environment          # which secret/keys are injected
```

(Do not use `kubectl get secret -o yaml` or `jsonpath='{.data}'` here — they
print the base64-encoded secret contents to your terminal.)

**Root cause (typical):** used `stringData` vs `data` incorrectly, or double /
missing base64 encoding — see `secret-base64-gotcha.md`.

**Fix:** correct the Secret yourself out-of-band (e.g. edit the local YAML and
`kubectl apply`, or recreate it through your normal secret-management
process — never echo decoded values into the terminal or repo), then restart
the Deployment so env vars are re-injected:

```bash
kubectl rollout restart deploy/<name>
kubectl describe pod <new-pod>        # confirm it mounts/reads the corrected secret
```

## Issue 2: Ingress returns 404 / default backend

```bash
kubectl get ingress
kubectl describe ingress <name>               # rules, backend, events
kubectl get pods -n ingress-nginx             # controller running?
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller | tail
kubectl get svc <backend-svc>                 # service exists?
kubectl get endpoints <backend-svc>           # non-empty endpoints?
```

**Common root causes:** wrong `ingressClassName`, `pathType` mismatch, Service
name/port typo, empty endpoints (selector/label mismatch).

**Fix & verify:** correct the Ingress/Service, then:

```bash
curl -H "Host: <host>" http://$(minikube ip)/path
kubectl describe ingress <name>               # confirm events are clean
```

## Issue 3: ConfigMap change not visible in Pod

```bash
kubectl get configmap <name> -o yaml
kubectl exec <pod> -- env | grep <KEY>
```

**Root cause:** env-injected ConfigMaps do not update running Pods — the
values are captured at container start.

**Fix:** `kubectl rollout restart deploy/<name>` and re-check `env` /
mounted files.

## Before / after evidence

| Issue | Before (command + output) | Fix applied | After (command + output) |
| :--- | :--- | :--- | :--- |
| Secret value wrong | | | |
| Ingress 404 | | | |
| ConfigMap stale | | | |

Paste your real `kubectl` output into the table.
