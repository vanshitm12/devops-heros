# Session 12: Kubernetes Ingress, ConfigMaps & Secrets

## Work

- Hands-on lab: [lab.md](lab.md)
- ConfigMap demo: [01-configmap/](01-configmap/) ([README](01-configmap/README.md))
- Secret demo: [02-secret/](02-secret/) ([README](02-secret/README.md))
- Ingress demos: [03-ingress/](03-ingress/) ([README](03-ingress/README.md))
- Full combined demo: [04-full-demo/](04-full-demo/) ([README](04-full-demo/README.md))
- Ingress vs Ingress Controller: [ingress-vs-ingress-controller.md](ingress-vs-ingress-controller.md)
- Troubleshooting runbook: [troubleshooting/runbook.md](troubleshooting/runbook.md)
  (Secret checks are keys-only — values are never printed)

## Status

Manifests and explanations complete; cluster execution and screenshots are
pending live runs on the student's own cluster.

> ⚠️ `02-secret/db-secret.yaml` and `04-full-demo/secret.yaml` contain a
> **non-production demonstration value** (`secretpassword`, base64-encoded)
> committed intentionally as a teaching example — base64 is encoding, not
> encryption. Do not reuse it in a real cluster, and never commit real secret
> values to Git; supply real values out-of-band (e.g. your secret manager).
