# Monitoring

`prometheus.yml` scrapes the app's `/metrics` endpoint at
`devops-demo.devops-demo.svc.cluster.local:8000` every 15s — the target is the
Kubernetes Service `devops-demo` in namespace `devops-demo`.

`alert-rules.yml` defines one rule: `up{job="devops-demo"} == 0` for `2m`,
severity `warning` — fires when Prometheus cannot scrape the app for two
minutes.

Run Prometheus with these files mounted and paste your own alerts/targets
screenshots as evidence; do not claim a run you did not perform.
