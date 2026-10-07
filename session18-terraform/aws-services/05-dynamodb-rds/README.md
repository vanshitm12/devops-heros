# DynamoDB & RDS — Database Services

## DynamoDB (NoSQL)

Fully managed, serverless key-value/document database — millisecond latency
at any scale.

- **Tables** — schema-less collections; no joins.
- **Items** — the rows; each item is a set of **attributes** (key/value).
- **Partition key** — required; hashes the item to a partition (e.g.
  `user_id`). Must have high cardinality.
- **Sort key** — optional; orders items within a partition (e.g.
  `timestamp`) enabling range queries.
- Capacity: on-demand or provisioned (RCU/WCU), GSIs/LSIs for alternate
  query patterns, DynamoDB Streams for change events.

**Use cases:** session stores, user profiles, carts, IoT telemetry,
leaderboards, Terraform state locking.

## RDS (Relational)

Managed relational databases — AWS handles patching, backups, failover.

- **Engines:** PostgreSQL, MySQL, MariaDB, Oracle, SQL Server (Aurora is the
  AWS-native variant).
- **DB instances** — sized like EC2 (`db.t3.micro` ...), EBS-backed storage
  (gp3/io1), storage autoscaling.
- **Security** — runs inside your VPC, secured by Security Groups; KMS
  encryption at rest, TLS in transit; IAM DB authentication option.
- **Backups** — automated snapshots + point-in-time restore (up to 35 days),
  manual snapshots kept until deleted.
- **Multi-AZ** — synchronous standby in another AZ for high availability
  (automatic failover; not a scaling feature).
- **Read replicas** — async copies for read scaling / reporting; can be
  promoted.

**Use cases:** transactional apps, e-commerce, anything needing SQL,
joins, or ACID guarantees.
