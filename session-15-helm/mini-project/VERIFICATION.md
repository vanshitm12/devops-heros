# Mini Project — Verified Helm Output

Commands actually run against `notes-chart/` (no cluster needed — install /
upgrade / rollback steps still require a live cluster and are documented in
`README.md`).

## `helm lint notes-chart`

```text
==> Linting notes-chart
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

## `helm template notes-dev notes-chart`

Renders all three templates correctly — `{{ }}` placeholders replaced with
release name `notes-dev` and `values.yaml` defaults:

```yaml
---
# Source: notes-chart/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: notes-dev-config
data:
  APP_NAME: "notes-app"
  ENVIRONMENT: "development"

---
# Source: notes-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: notes-dev-svc
spec:
  type: NodePort
  selector:
    app: notes-dev
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30090

---
# Source: notes-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: notes-dev-deploy
  labels:
    app: notes-dev
    environment: development
spec:
  replicas: 1
  selector:
    matchLabels:
      app: notes-dev
  template:
    metadata:
      labels:
        app: notes-dev
    spec:
      containers:
        - name: notes
          image: "nginx:1.24"
          ports:
            - containerPort: 80
          envFrom:
            - configMapRef:
                name: notes-dev-config
```

## `helm template notes-prod notes-chart -f notes-chart/values-prod.yaml`

Production overrides render correctly (excerpt):

```text
  name: notes-prod-config
  ENVIRONMENT: "production"
  name: notes-prod-svc
  name: notes-prod-deploy
  replicas: 3
          image: "nginx:1.25"
```

## Remaining steps (require a cluster)

`helm install`, `helm upgrade`, `helm history`, `helm rollback` need a running
cluster — run them on your own Minikube and paste output as evidence.
