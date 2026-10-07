# Session 17: Complete CI/CD & DevSecOps

The DevSecOps pipeline is implemented in the shared root workflows and the
`final-devops-project/` tree — one app, one pipeline, no duplicates.

## Pipeline flow (as implemented)

```text
Code push / PR touching final-devops-project/**
        ↓
actions/checkout + setup-python 3.11
        ↓
Install app deps + security tooling
(bandit==1.8.3, pip-audit==2.9.0, detect-secrets==1.5.0)
        ↓
Unit test        python -m unittest discover -s tests -v
        ↓
SAST             bandit -q -r application -x application/tests
        ↓
SCA              pip-audit -r application/requirements.txt
        ↓
Secret scan      detect-secrets scan → fail on any finding
        ↓
Docker build     docker build -t devops-demo:scan application/
        ↓
Container scan   Trivy gate: exit-code 1 on HIGH/CRITICAL (ignore-unfixed)
        ↓
Security gate    job fails → nothing published
        ↓
Push image       ghcr.io/<owner>/devops-demo:<sha>  (main push only)
        ↓
Deploy (manual)  devops-cd.yml workflow_dispatch → helm upgrade --install
```

## Mapping to the required security stages

| Required | Implemented by |
| :--- | :--- |
| SAST | `bandit` static analysis of the Flask source |
| SCA | `pip-audit` against `requirements.txt` |
| Secret scanning | `detect-secrets scan` + JSON results check |
| Container image scanning | `aquasecurity/trivy-action@v0.30.0` |
| Security gates | CI job fails (exit-code 1) → `publish` job skipped |
| Registry | GHCR via `GITHUB_TOKEN`, `packages: write` |
| K8s deployment | `helm upgrade --install` in the manual CD workflow, gated by the `production` environment |

## Reproduce locally

```bash
cd final-devops-project/application
pip install -r requirements.txt bandit pip-audit detect-secrets
python -m unittest discover -s tests -v
bandit -q -r . -x tests
pip-audit -r requirements.txt
detect-secrets scan .
docker build -t devops-demo:scan .
trivy image --severity HIGH,CRITICAL --ignore-unfixed devops-demo:scan
```

## Evidence

No pipeline runs are claimed here — push a change or dispatch the workflow in
your own fork/environment and paste real output:

| Stage | Evidence |
| :--- | :--- |
| Tests | `<output>` |
| Bandit / pip-audit / detect-secrets | `<output>` |
| Trivy gate | `<output>` |
| GHCR publish | `<output>` |
| Helm deploy | `<output>` |

## Links

- App + Dockerfile: [../final-devops-project/application/](../final-devops-project/application/)
- CI pipeline: [../.github/workflows/devops-ci.yml](../.github/workflows/devops-ci.yml)
- CD pipeline: [../.github/workflows/devops-cd.yml](../.github/workflows/devops-cd.yml)
- K8s/Helm deploy target: [../final-devops-project/helm/devops-demo/](../final-devops-project/helm/devops-demo/)
- Security notes: [../final-devops-project/security/README.md](../final-devops-project/security/README.md)
