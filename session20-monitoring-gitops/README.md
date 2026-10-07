# Session 20: Monitoring, Observability & GitOps

Working artifacts live in `../final-devops-project/`:
`monitoring/prometheus.yml`, `monitoring/alert-rules.yml`,
`gitops/argocd-application.yaml`, and the app's `/metrics` endpoint.

## Task 1: Monitoring

- **Metrics** — numeric measurements over time (CPU %, memory, request
  count). Our app exposes `demo_requests_total` at `/metrics`; Prometheus
  scrapes it every 15s.
- **Logs** — timestamped event lines (kubectl logs, app stdout) for
  debugging individual events.
- **Alerts** — rules on metrics that fire notifications. Ours:
  `up{job="devops-demo"} == 0` for `2m`, severity `warning` — app
  unreachable for two minutes.
- **CPU / memory utilization** — via `kubectl top pods` (metrics-server) or
  container metrics in Prometheus (`container_cpu_usage_seconds_total`).
- **Application health** — `/health` endpoint backing the liveness/readiness
  probes in the Helm chart.

## Task 2: Observability — the three pillars

| Pillar | What it answers | Tools |
| :--- | :--- | :--- |
| **Metrics** | "Is it healthy right now?" aggregated signals, cheap to store & alert on | Prometheus, Grafana, CloudWatch |
| **Logs** | "What happened?" discrete event detail | Loki, ELK, Fluentd, CloudWatch Logs |
| **Traces** | "Where was it slow / where did it fail?" request path across services | Jaeger, Tempo, OpenTelemetry, X-Ray |

**Why observability is required:** monitoring tells you *that* something is
wrong; observability lets you ask *new questions* about unknown failure modes
in a distributed system — you can't predefine every alert.

**Kubernetes observability:** kubelet/cAdvisor container metrics, API-server
metrics, cluster events, Pod logs via stdout, node exporter; typical stack =
Prometheus + Grafana + Loki + Tempo (or vendor equivalents).

## Task 3: GitOps

- **What is GitOps?** Operations model where **Git is the single source of
  truth** for both app code and desired infrastructure/cluster state.
- **Declarative configuration** — you commit *what* you want (manifests,
  Helm values), not *how* to get there.
- **Continuous reconciliation** — an agent (Argo CD / Flux) watches Git and
  converges the live cluster to match, and flags/reverts drift.
- **Workflow:** commit change → CI builds/tests/pushes image → update image
  tag in the chart/values → Argo CD detects diff → `sync` → cluster updated.
- **Kubernetes + GitOps:** see `final-devops-project/gitops/argocd-application.yaml`
  — Application pointing at `final-devops-project/helm/devops-demo` on `main`,
  **manual sync only**.

## Evidence placeholders

| Item | Paste here |
| :--- | :--- |
| Prometheus targets up | `<screenshot>` |
| `up{job="devops-demo"} == 0` alert firing | `<screenshot>` |
| Argo CD app synced | `<screenshot>` |

## Submission index links

- Monitoring configs: [../final-devops-project/monitoring/prometheus.yml](../final-devops-project/monitoring/prometheus.yml),
  [../final-devops-project/monitoring/alert-rules.yml](../final-devops-project/monitoring/alert-rules.yml)
- GitOps: [../final-devops-project/gitops/argocd-application.yaml](../final-devops-project/gitops/argocd-application.yaml)
- App metrics endpoint source: [../final-devops-project/application/app.py](../final-devops-project/application/app.py)
