# Session 6: Docker Fundamentals — Hello World Applications

Six Hello World web apps, each with its own folder and Dockerfile. Build/run
instructions and per-app ports are in
[../session6-7-docker/README.md](../session6-7-docker/README.md).

## Applications

| Folder | Stack | Port |
| :--- | :--- | :--- |
| [../session6-7-docker/nodejs-app/](../session6-7-docker/nodejs-app/) | Node.js built-in `http` | 3000 |
| [../session6-7-docker/python-app/](../session6-7-docker/python-app/) | Python stdlib `http.server` | 8000 |
| [../session6-7-docker/java-app/](../session6-7-docker/java-app/) | JDK built-in `HttpServer` | 8080 |
| [../session6-7-docker/Apache-app/](../session6-7-docker/Apache-app/) | Apache httpd static | 80 |
| [../session6-7-docker/React-app/](../session6-7-docker/React-app/) | React 18 + Vite build → nginx | 80 |
| [../session6-7-docker/nginx-app/](../session6-7-docker/nginx-app/) | nginx static | 80 |

## Verification performed locally

All six images built with `docker build` and were run; each returned its
Hello World page via `curl` on the documented port.

## Supporting files

- [../session6-7-docker/docker.md](../session6-7-docker/docker.md) — docker command notes
- [../session6-7-docker/docker-compose-app/docker-compose.yml](../session6-7-docker/docker-compose-app/docker-compose.yml) — compose example
