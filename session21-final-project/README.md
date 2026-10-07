# Session 21: Final DevOps Project & Troubleshooting

## Project overview

The complete end-to-end project is `../final-devops-project/` — Flask app →
GitHub Actions CI (tests + SAST/SCA/secrets/Trivy gate → GHCR) → manual CD
(`helm upgrade`) → Kubernetes via Helm → Prometheus monitoring + alert →
Argo CD GitOps. Infrastructure code: `../session18-terraform/` and
`../session19-cloud-terraform/`.

```text
App → Git → GitHub → CI (test/scan) → Docker image → GHCR
    → manual CD → Helm → Kubernetes (Deploy/Svc/CM/Secret ref/Ingress/HPA/PVC/probes)
    → Prometheus (/metrics + alert) → Argo CD (manual sync)
```

## What's real vs. what's pending

Real, locally verified in this repo:

- Flask unit tests pass (`python -m unittest discover -s tests -v` — 3 tests).
- Docker image builds and serves all 3 routes.
- `helm lint` / `helm template` render the chart (incl. ingress/hpa/pvc/secret
  variants).

**Missing live evidence** (requires your own accounts/cluster — intentionally
not fabricated): GitHub Actions CI/CD run screenshots, GHCR package, live
Kubernetes deploy, Prometheus targets/alerts page, Argo CD sync screen,
`terraform plan/apply` output. Fill `final-devops-project/README.md`'s
evidence table when you run them.

## Final troubleshooting challenge

Break one of these in your own environment, then identify → investigate →
find root cause → fix → verify → document:

1. **Wrong image tag** in `helm/devops-demo/values.yaml` → `ImagePullBackOff`.
   `kubectl describe pod` Events → fix tag → `helm upgrade` → pods Running.
2. **Service selector ≠ Deployment labels** → `kubectl get endpoints` shows
   `<none>` → `--show-labels` comparison → correct selector.
3. **Probe path typo** (`/helth`) → `CrashLoopBackOff`/`Unhealthy` events →
   `kubectl describe` → fix path.
4. **Missing ConfigMap** (helm `--set` release name mismatch) →
   `CreateContainerConfigError` → `kubectl describe pod`.
5. **Prometheus target down** — wrong scrape host/port →
   *Status → Targets* shows DOWN → fix `monitoring/prometheus.yml`.
6. **Argo CD OutOfSync** — manual `kubectl` edit drifts from Git →
   `argocd app diff` → sync (or revert) to reconcile.

Always follow: `get` → `describe` → `events` → `logs` → `exec` → fix →
verify, and record before/after output.

## Submission index links

- Final project root: [../final-devops-project/README.md](../final-devops-project/README.md)
- CI/CD: [../.github/workflows/devops-ci.yml](../.github/workflows/devops-ci.yml), [../.github/workflows/devops-cd.yml](../.github/workflows/devops-cd.yml)
- Infra: [../session18-terraform/README.md](../session18-terraform/README.md), [../session19-cloud-terraform/README.md](../session19-cloud-terraform/README.md)
- Monitoring/GitOps: [../final-devops-project/monitoring/](../final-devops-project/monitoring/), [../final-devops-project/gitops/](../final-devops-project/gitops/)
