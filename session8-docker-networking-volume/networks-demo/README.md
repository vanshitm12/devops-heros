# Session 8: Docker Networking & Volume Homework

## Task 1: Container Networking (docker-compose)

`docker-compose.yml` creates 3 containers (`frontend` = nginx, `backend` =
nginx, `database` = mysql:8.0) and 3 named bridge networks
(`frontend-net`, `db-net`, `ops-net`).

- `frontend` is on `frontend-net`
- `backend` is on **exactly two** networks: `frontend-net` + `db-net`
- `database` is on `db-net` (+ `ops-net` for management isolation)

So `frontend` can resolve `backend`, and `backend` can resolve `database`,
but `frontend` **cannot** reach `database` directly — classic tier isolation.

### Setup

```bash
cd networks-demo
cp .env.example .env      # then edit .env with real passwords (never commit it)
docker compose up -d
```

Compose fails fast if the passwords are unset (the `:?` syntax).

### Check connectivity

```bash
# backend on exactly two networks
docker inspect networks-demo-backend-1 --format '{{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{end}}'

# frontend <-> backend DNS resolution + connectivity
docker exec networks-demo-frontend-1 ping -c 2 backend
docker exec networks-demo-frontend-1 wget -qO- http://backend

# backend <-> database DNS resolution
docker exec networks-demo-backend-1 ping -c 2 database

# frontend can NOT reach database (expected to fail)
docker exec networks-demo-frontend-1 ping -c 2 database
```

(Paste your own output as evidence — do not copy someone else's.)

## Task 2: Host Network (Apache httpd)

```bash
docker pull httpd:2.4-alpine
docker run -d --name apache-host --network host httpd:2.4-alpine
curl http://localhost          # Apache serves on port 80 directly
```

> ⚠️ **Docker Desktop caveat (macOS/Windows):** host networking is natively a
> Linux feature. Recent Docker Desktop releases support it only as an
> **opt-in** setting (*Settings → Resources → Network → Enable host
> networking*); without enabling it, `--network host` does not expose the
> container on your machine's port 80. If unavailable or not enabled, use
> `-p 80:80` instead to get the same result.

## Task 3: Bind Mount

The `frontend` service already bind-mounts `./html` to nginx's docroot:

```bash
docker compose up -d frontend
curl http://localhost:8080          # shows "Hello students"
# edit html/index.html on your machine
echo "<h1>Updated without restart</h1>" > html/index.html
curl http://localhost:8080          # change is live — no restart needed
```

## Task 4: Overlay Networks (research notes)

- An **overlay network** spans **multiple Docker hosts** (a Docker Swarm), so
  containers on different machines can talk as if on one LAN.
- Traffic travels over a VXLAN tunnel (UDP 4789); each host keeps a local
  view and Docker's gossip protocol (Serf) distributes member info.
- Use cases: Swarm services (`docker service create --network ...`),
  multi-host apps, encryption between hosts (`--opt encrypted`).
- Overlay networks do function on a single-node Swarm (`docker swarm init`
  then `docker network create -d overlay`), but the multi-host behavior —
  containers on different machines sharing a network — needs 2+ Swarm nodes
  to actually demonstrate.

## Cleanup

```bash
docker compose down -v
docker rm -f apache-host
```
