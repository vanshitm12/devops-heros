# Docker

The Dockerfile for this project lives at `../application/Dockerfile`
(Python 3.11-slim, non-root `appuser`, gunicorn serving `app:app` on port 8000).

```bash
# build from the application directory
docker build -t devops-demo ../application
# or from the repo root
docker build -t devops-demo final-devops-project/application

docker run -d -p 8000:8000 --name devops-demo devops-demo

curl http://localhost:8000/          # {"message":"Hello World from DevOps"}
curl http://localhost:8000/health    # {"status":"ok"}
curl http://localhost:8000/metrics   # Prometheus text: demo_requests_total

docker rm -f devops-demo
```
