# IAM — Identity and Access Management (Governance)

**What is IAM?** AWS's identity service: controls **who** can do **what** on
which resources. Global (not regional) and free.

## Core concepts

- **Users** — a person or application with long-term credentials (console
  password and/or access keys).
- **Groups** — collections of users; attach policies to a group, not to
  individuals.
- **Roles** — identities with **temporary** credentials, assumed via STS.
  Used for EC2 instance profiles, Lambda, cross-account access, federated
  (SSO/IdP) sign-in.
- **Policies** — JSON documents granting `Action` on `Resource` with an
  `Effect` of Allow/Deny (e.g. `s3:GetObject` on `arn:aws:s3:::bucket/*`).
- **Permissions** — the effective set = identity policies + resource policies
  + permission boundaries; explicit Deny always wins.
- **Least privilege** — grant only the exact actions/resources needed;
  start small, expand from observed denials (access advisor, access analyzer).

## Best practices

- No root usage; enable MFA; use roles instead of access keys where possible.
- Rotate credentials; never put keys in code/Git.
- Use groups + managed policies; review with IAM Access Analyzer.

## Common use cases

Human admin access via SSO, EC2/Lambda service roles, CI/CD deploy roles
(OIDC), cross-account read-only audit roles.
