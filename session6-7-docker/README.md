# Session 6-7: Docker Hello World Applications

Six minimal Hello World web apps, each in its own folder with a Dockerfile.

| Folder | Stack | Container port |
| :--- | :--- | :--- |
| `nodejs-app/` | Node.js built-in `http` module | 3000 |
| `python-app/` | Python stdlib `http.server` | 8000 |
| `java-app/` | JDK built-in `HttpServer` | 8080 |
| `Apache-app/` | Apache httpd serving a static page | 80 |
| `React-app/` | React 18 + Vite build, served by nginx (multi-stage) | 80 |
| `nginx-app/` | nginx serving a static page | 80 |

## Build & run (per app)

```bash
# from inside each app folder
docker build -t <folder-name> .
docker run -d -p 8080:<container-port> --name <folder-name> <folder-name>
curl http://localhost:8080
```

Examples:

```bash
cd nodejs-app
docker build -t nodejs-app .
docker run -d -p 3000:3000 --name nodejs-app nodejs-app
curl http://localhost:3000
# <h1>Hello World from Node.js + Docker!</h1>

cd ../python-app
docker build -t python-app .
docker run -d -p 8000:8000 --name python-app python-app
curl http://localhost:8000

cd ../java-app
docker build -t java-app .
docker run -d -p 8081:8080 --name java-app java-app
curl http://localhost:8081

cd ../Apache-app
docker build -t apache-app .
docker run -d -p 8082:80 --name apache-app apache-app
curl http://localhost:8082

cd ../React-app
docker build -t react-app .
docker run -d -p 8083:80 --name react-app react-app
curl http://localhost:8083

cd ../nginx-app
docker build -t nginx-app .
docker run -d -p 8084:80 --name nginx-app nginx-app
curl http://localhost:8084
```

Check the running containers:

```bash
docker ps
```

Stop and clean up when done:

```bash
docker stop nodejs-app python-app java-app apache-app react-app nginx-app
docker rm   nodejs-app python-app java-app apache-app react-app nginx-app
```

## Multi-stage build demo

See `multi-stage-dockerfile/` and `multi-stage-evidence.md`. The app listens on
container port **3000**; map host port 8080 to it:

```bash
cd multi-stage-dockerfile
docker build -t multi-stage-app .
docker run -d -p 8080:3000 --name multi-stage-app multi-stage-app
curl http://localhost:8080
# Hello World from Docker Multi-Stage Build!
docker ps
```
