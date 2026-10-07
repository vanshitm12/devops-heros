# Session 7: Docker Images — Multi-Stage Build

Multi-stage Dockerfile demo in
[../session6-7-docker/multi-stage-dockerfile/](../session6-7-docker/multi-stage-dockerfile/):
stage 1 installs dependencies in `node:24-alpine`, stage 2 copies only the
production artifacts into a fresh `node:24-alpine` image.

## Run

The app listens on container port **3000**; map host port 8080 to it:

```bash
cd ../session6-7-docker/multi-stage-dockerfile
docker build -t multi-stage-app .
docker run -d -p 8080:3000 --name multi-stage-app multi-stage-app
curl http://localhost:8080   # Hello World from Docker Multi-Stage Build!
docker ps                    # shows 0.0.0.0:8080->3000
```

## Evidence

- [../session6-7-docker/multi-stage-evidence.md](../session6-7-docker/multi-stage-evidence.md) —
  submission template with name/enrollment fields and slots for `curl` and
  `docker ps` output (fill in before submission).

## Verification performed locally

The multi-stage image built successfully and returned
`Hello World from Docker Multi-Stage Build!` on `localhost:8080`.
