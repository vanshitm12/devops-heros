# Kubernetes manifests

Plain-manifest equivalents of `helm/devops-demo`. Apply into the
`devops-demo` namespace:

```bash
kubectl create namespace devops-demo
kubectl apply -n devops-demo -f kubernetes/configmap.yaml
kubectl apply -n devops-demo -f kubernetes/pvc.yaml
kubectl apply -n devops-demo -f kubernetes/deployment.yaml
kubectl apply -n devops-demo -f kubernetes/service.yaml
kubectl apply -n devops-demo -f kubernetes/hpa.yaml
kubectl apply -n devops-demo -f kubernetes/ingress.yaml
```

## Image

`deployment.yaml` ships with placeholder image
`ghcr.io/REPLACE_OWNER/devops-demo:REPLACE_TAG`. Before applying, replace them
with an image your cluster can pull — a real image published by the CI
workflow, or a locally built one. With minikube:

```bash
docker build -t devops-demo:local final-devops-project/application
minikube image load devops-demo:local
# then set image to devops-demo:local (imagePullPolicy: IfNotPresent keeps it local)
```

If `ghcr.io/REPLACE_OWNER/...` is a **private** GHCR package, the cluster also
needs an `imagePullSecret`, or make the package public.

## Optional secret

The Deployment references an optional Secret named `devops-demo-secret`
(`envFrom.secretRef` with `optional: true`), so Pods start without it. To
create it safely — keep the value in a local, git-ignored file rather than
typing it on the command line (shell history/argv are not safe for secrets):

```bash
umask 077
secret_file=$(mktemp)
read -rsp 'API key: ' api_key; printf '\n'
printf '%s' "$api_key" > "$secret_file"
unset api_key
kubectl create secret generic devops-demo-secret \
  --from-file="API_KEY=$secret_file" -n devops-demo
```

This keeps the value out of shell history/argv. Afterwards, securely dispose
of the temp file you just created (its path is in `$secret_file`); keep it
out of Git either way — never commit a Secret manifest containing real
values.
