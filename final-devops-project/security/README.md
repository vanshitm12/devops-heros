# DevSecOps

Security checks are enforced in the root CI workflow
`.github/workflows/devops-ci.yml` — no secrets are stored here.

| Stage | Tool | Gate |
| :--- | :--- | :--- |
| SAST | `bandit` | fails on Python code findings |
| SCA | `pip-audit` | fails on vulnerable dependencies |
| Secret scan | `detect-secrets` | fails if any potential secret is found |
| Image scan | Trivy (`aquasecurity/trivy-action`) | fails on HIGH/CRITICAL, `ignore-unfixed: true` |

Local equivalents:

```bash
pip install bandit pip-audit detect-secrets
bandit -q -r application -x application/tests
pip-audit -r application/requirements.txt
detect-secrets scan .
docker build -t devops-demo:scan application
trivy image --severity HIGH,CRITICAL devops-demo:scan
```
