# EC2 — Elastic Compute Cloud

**What is EC2?** Resizable virtual machines in AWS — the classic IaaS compute
service.

## Core concepts

- **AMI** — Amazon Machine Image: the template (OS + packages) an instance
  boots from (e.g. Amazon Linux 2023).
- **Instance types** — CPU/RAM/network families: `t3`/`t4g` burstable,
  `m` general, `c` compute, `r` memory, GPU families.
- **Key pairs** — SSH public key on the instance + private key you keep;
  used for Linux login (or use SSM Session Manager instead).
- **Security Groups** — stateful virtual firewall on the instance:
  allow inbound/outbound rules by port/CIDR/SG.
- **EBS** — Elastic Block Store: network-attached persistent volumes
  (gp3 SSD, io2, st1 throughput HDD); survives reboot, optional encryption.
- **Public vs private IP** — public IP/EIP reaches the internet via IGW;
  private IP is VPC-internal only.
- **Instance lifecycle** — pending → running →
  stopping → stopped → (start) / terminated; also hibernate, reboot.
  On terminate the root EBS volume is deleted by default.

## Common use cases

Web/app servers, bastion hosts, self-managed databases, lift-and-shift
workloads, batch workers (with Auto Scaling Groups / Spot).
