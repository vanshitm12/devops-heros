# Final DevOps Project

End-to-end demo: a small Flask app packaged with Docker, deployed to
Kubernetes via Helm, secured/scanned in CI, monitored with Prometheus, and
managed by GitOps (Argo CD).

## Architecture

```text
Git push
   │
   ▼
GitHub Actions CI (.github/workflows/devops-ci.yml)
   unit tests → Bandit (SAST) → pip-audit (SCA) → detect-secrets
   → Docker build → Trivy HIGH/CRITICAL gate → push to GHCR (main only)
   │
   ▼
GitHub Actions CD (.github/workflows/devops-cd.yml, manual)
   helm upgrade --install devops-demo → Kubernetes
   │
   ▼
Prometheus scrapes /metrics ──▶ alert: up{job="devops-demo"} == 0
   │
   ▼
Argo CD Application (gitops/) — manual sync only; an alternative deploy
mode, NOT to be run concurrently with the CD workflow on the same release
```

## Layout

| Path | Contents |
| :--- | :--- |
| `application/` | Flask app (`/`, `/health`, `/metrics`), `requirements.txt`, `tests/`, `Dockerfile` |
| `docker/` | Docker build/run notes |
| `kubernetes/` | Plain manifests: Deployment, Service, ConfigMap, Ingress, HPA, PVC (+ secret reference notes) |
| `helm/devops-demo/` | Parameterized chart (ingress/hpa/persistence/secret off by default) |
| `monitoring/` | Prometheus scrape config + alert rule |
| `gitops/` | Argo CD `Application` (manual sync) |
| `security/` | DevSecOps tooling notes |
| `terraform/` | Pointer to the session18/19 Terraform projects |

## Application

```bash
cd application
python -m pip install -r requirements.txt
python -m unittest discover -s tests -v     # 3 tests
PORT=8000 python app.py
curl http://localhost:8000/         # {"message":"Hello World from DevOps"}
curl http://localhost:8000/health   # {"status":"ok"}
curl http://localhost:8000/metrics  # demo_requests_total <n>
```

## Docker

See `docker/README.md`. The image builds from `python:3.11-slim`, runs as a
non-root user, and exposes port 8000.

## Kubernetes (plain manifests)

`kubernetes/deployment.yaml` uses the placeholder image
`ghcr.io/REPLACE_OWNER/devops-demo:REPLACE_TAG` — replace it with a real
published image first (or a locally built one, e.g. via
`minikube image load`; see `kubernetes/README.md`).

```bash
kubectl create namespace devops-demo
kubectl apply -n devops-demo -f kubernetes/
kubectl -n devops-demo get pods,svc,hpa
```

The Deployment optionally consumes a pre-provisioned Secret named
`devops-demo-secret` — see `kubernetes/README.md` for creating it safely
from a local git-ignored file (no value is committed).

## Helm

```bash
helm lint helm/devops-demo
helm template dev helm/devops-demo                                   # defaults
helm template dev helm/devops-demo --set ingress.enabled=true        # variations
helm template dev helm/devops-demo --set hpa.enabled=true \
  --set persistence.enabled=true --set secret.enabled=true
helm upgrade --install devops-demo helm/devops-demo \
  --namespace devops-demo --create-namespace \
  --set-string image.repository=ghcr.io/<actual-owner>/devops-demo \
  --set-string image.tag=<published-sha> --wait
```

For a locally built image instead:

```bash
docker build -t devops-demo:local application
minikube image load devops-demo:local          # or: kind load / remote push
helm upgrade --install devops-demo helm/devops-demo \
  --namespace devops-demo --create-namespace \
  --set-string image.repository=devops-demo \
  --set-string image.tag=local --wait
```

If the GHCR package is private, the cluster needs an `imagePullSecret` to
pull it (or make the package public) — otherwise Pods stick at
`ImagePullBackOff`.

## Infrastructure

Terraform projects: `session18-terraform/terraform-s3-demo/` and
`session19-cloud-terraform/` — `init`/`fmt`/`validate`/`plan` only; do not
apply against shared AWS accounts.

## CI/CD

CI runs on pushes/PRs touching `final-devops-project/**`; CD is manual
(`workflow_dispatch`) and requires the `KUBECONFIG_B64` secret and a published
image tag (full commit SHA). No live pipeline runs are claimed here — capture
your own run screenshots.

Notes:

- The CD job targets the GitHub `environment: production`. The name alone is
  not protection — configure **required reviewers** on that environment in
  repo *Settings → Environments* to gate deploys.
- The published GHCR image is `ghcr.io/<owner>/devops-demo:<sha>`. If the
  package is private, the cluster needs an `imagePullSecret` to pull it
  (or make the package public).
- **Deploy modes are mutually exclusive:** either deploy via the CD workflow,
  or let Argo CD manage the `devops-demo` release — not both at once. For the
  GitOps path, commit the published image tag into
  `helm/devops-demo/values.yaml` before syncing; Argo CD is configured for
  **manual sync only** (no auto-reconciliation), so it does not self-correct
  drift — use `argocd app sync devops-demo`.

## Monitoring

`monitoring/` — Prometheus scrapes
`devops-demo.devops-demo.svc.cluster.local:8000/metrics`; alert
`up{job="devops-demo"} == 0` for 2m (severity warning).

## GitOps

`gitops/argocd-application.yaml` points Argo CD at
`final-devops-project/helm/devops-demo` on `main`, with **manual sync only**
(it does not auto-reconcile drift). Commit the published image tag in
`values.yaml` before syncing, and do not run the CD workflow against the same
release concurrently.

## Diagnostics exercises (troubleshooting practice)

Try breaking one thing at a time and diagnose before fixing:

1. Set `image.tag` to a bogus value → observe `ImagePullBackOff`
   (`kubectl describe pod`, Events).
2. Rename the Service selector label → observe `<none>` endpoints
   (`kubectl get endpoints`, `--show-labels`).
3. Typo a probe path (`/helth`): a **liveness** probe typo restarts the
   container (CrashLoopBackOff); a **readiness**-only typo leaves the Pod
   Running but never `Ready` — check `kubectl describe` probe events and
   `kubectl get pods` READY column.
4. Remove/rename the referenced ConfigMap → Pod fails at start with
   `CreateContainerConfigError` (`kubectl describe pod` Events name the
   missing ConfigMap).
5. Invalid HPA (`minReplicas` > `maxReplicas`) — the API server rejects it;
   preview safely with `kubectl apply --dry-run=server -f hpa.yaml` rather
   than applying a broken autoscaler.

For each: get → describe → events → logs → fix → verify. Record before/after.

## Evidence placeholders

| Step | Command | My output/screenshot |
| :--- | :--- | :--- |
| Unit tests | `python -m unittest discover -s tests -v` | |
| Docker run | `curl localhost:8000/health` | |
| K8s deploy | `kubectl get pods` | |
| Helm render | `helm template dev helm/devops-demo` | |
| CI run | GitHub Actions → devops-ci | |
| Alert firing | Prometheus Alerts page | |
| Argo CD sync | `argocd app get devops-demo` | |

### Local verification (2026-10-07)

An isolated Minikube profile, `devops-heros-lab`, was started for this check
and stopped afterward. The previous `docker-desktop` kubectl context was
restored. These results do not establish that the cloud pipeline or AWS
infrastructure has run.

| Check | Observed result |
| :--- | :--- |
| `helm upgrade --install devops-demo` with `devops-demo:local` | Release deployed in `devops-demo`; both application Pods were `1/1 Running` |
| Service port-forward, `GET /` | `{"message":"Hello World from DevOps"}` |
| Service port-forward, `GET /health` | `{"status":"ok"}` |
| Service port-forward, `GET /metrics` | Prometheus text included `demo_requests_total` |
| Session 10 rolling update | nginx 1.24 to 1.25 rolled out; Deployment history showed two revisions |
| Session 11 ClusterIP | In-cluster request returned HTTP 200 and the full Service FQDN resolved |
| Session 13 HPA | Deployment and HPA applied; metrics were not yet available immediately after enabling metrics-server, so scaling was **not** verified |
