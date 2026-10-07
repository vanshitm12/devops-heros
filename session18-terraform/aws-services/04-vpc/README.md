# VPC — Virtual Private Cloud (Networking)

**What is VPC?** Your own logically isolated virtual network inside AWS where
you launch resources.

## Core concepts

- **CIDR** — the VPC's IP range, e.g. `10.0.0.0/16`; subnets take slices of
  it (`10.0.1.0/24`).
- **Subnets** — per-AZ IP ranges inside the VPC.
- **Route tables** — decide where traffic goes (`local` routes + `0.0.0.0/0`
  targets); associated per subnet.
- **Internet Gateway (IGW)** — VPC ↔ internet attachment; a public subnet's
  route table points `0.0.0.0/0` at the IGW.
- **NAT Gateway** — lets private-subnet instances reach the internet
  outbound (updates, API calls) without being reachable inbound.
- **Security Groups** — stateful instance-level firewall (allow rules only).
- **Network ACLs** — stateless subnet-level firewall (allow + deny rules,
  evaluated in order).
- **Public vs private subnet** — public = route to IGW; private = no IGW
  route (usually NAT for egress). Put load balancers public, apps/DBs
  private.

## Typical layout

`10.0.0.0/16` → public subnets in 2 AZs (ALB, NAT) + private subnets in 2
AZs (EC2, RDS) → SGs chaining ALB → app → DB.
