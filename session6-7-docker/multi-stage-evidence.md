# Docker Multi-Stage Build — Evidence

**Name:** <your name>
**Enrollment number:** <your enrollment number>

## Steps run

```bash
cd multi-stage-dockerfile
docker build -t multi-stage-app .
docker run -d -p 8080:3000 --name multi-stage-app multi-stage-app
```

## Application output

```bash
curl http://localhost:8080
```

Expected response (app listens on container port 3000, mapped to host 8080):

```text
Hello World from Docker Multi-Stage Build!
```

**My output / screenshot:**

```text
<paste your curl output or screenshot here>
```

## Running container proof

```bash
docker ps
```

**My output / screenshot:**

```text
<paste your `docker ps` output showing multi-stage-app on 0.0.0.0:8080->3000 here>
```

## Task 3: 3+ deployed app types

Deployed containers (e.g. nodejs-app, python-app, java-app — see `README.md`):

```text
<paste your `docker ps` output showing at least 3 app containers here>
```
