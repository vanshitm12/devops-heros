Resources:

- https://docs.docker.com/engine/network/drivers/

## Submission index

- Compose networking/volume demo: [networks-demo/README.md](networks-demo/README.md)
  and [networks-demo/docker-compose.yml](networks-demo/docker-compose.yml) —
  3 containers over 3 named bridge networks (backend on exactly two),
  env-interpolated MySQL passwords, bind-mounted `index.html`, and a
  host-network/overlay-network runbook.
- Root compose examples: [docker-compose.yml](docker-compose.yml),
  [docker-compose-app/docker-compose.yml](docker-compose-app/docker-compose.yml),
  [demo/docker-compose.yml](demo/docker-compose.yml)

## Status

Compose file validated with `docker compose config` (fails fast without env
secrets, as designed). Host-networking and multi-host overlay exercises are
documented but were **not** run live — Docker Desktop host networking is
opt-in and overlay's multi-host behavior needs 2+ Swarm nodes.
