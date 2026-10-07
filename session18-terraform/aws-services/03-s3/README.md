# S3 — Simple Storage Service

**What is S3?** Object storage: virtually unlimited, durable
(11 nines by design), accessed over HTTP APIs.

## Core concepts

- **Buckets** — top-level containers; names are **globally unique** and live
  in a chosen region.
- **Objects** — the files: key (name/path), value (data, up to 5 TB),
  metadata, version ID.
- **Storage classes** — Standard, Intelligent-Tiering, Standard-IA,
  One Zone-IA, Glacier Instant/Flexible/Deep Archive — trade
  availability/retrieval time for cost.
- **Versioning** — keeps every overwrite/delete as a new version; protects
  against accidental loss; required for MFA-delete.
- **Lifecycle policies** — rules to transition objects to cheaper classes or
  expire them (e.g. move to Glacier after 90 days, delete after 7 years).
- **Encryption** — SSE-S3 (AES256, default), SSE-KMS, SSE-C, or client-side.
- **Bucket policies** — resource-based JSON policies controlling who can
  access the bucket/objects; combine with Block Public Access.

## Common use cases

Static website assets, backups/restore, data lakes, log archives, artifacts,
Terraform state backend (with DynamoDB locking).
