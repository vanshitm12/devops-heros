# Session 19: Cloud & Terraform in Action

End-to-end AWS project — VPC → subnet → internet gateway/route → security
group → EC2 → private encrypted S3 bucket.

## Architecture

```text
VPC 10.0.0.0/16
 └── Subnet 10.0.1.0/24 (public, route 0.0.0.0/0 -> IGW)
      └── EC2 (Amazon Linux 2023 via SSM public parameter)
           └── SG: inbound 8000/tcp from allowed_cidr only, no SSH,
               all outbound
S3 bucket: private, AES256, public access blocked
```

Dependencies are implicit: `aws_subnet` references `aws_vpc`, the SG
references the VPC, the instance references subnet + SG — Terraform builds
the graph itself.

## Concepts demonstrated

| Concept | Where |
| :--- | :--- |
| Providers | `provider.tf` — `hashicorp/aws ~> 5.0` |
| Variables | `variables.tf` (`aws_region`, `instance_type` = t3.micro, `bucket_name`, `allowed_cidr` — both required, no default) |
| Data source | AMI resolved from the AWS **public SSM parameter** `al2023-ami-kernel-default-x86_64` — always current, no hardcoded AMI |
| Resources | VPC, subnet, IGW, route table, SG, EC2, S3 (+encryption, public access block) |
| Outputs | `outputs.tf` — vpc/subnet/instance/bucket IDs |
| State | `terraform.tfstate` after apply — the record Terraform diffs against |

## Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan        # review only
# terraform apply / destroy — only against your own sandbox account,
# with credentials supplied via AWS_PROFILE / env vars (never in Git)
```

`terraform.tfvars` contains placeholders — fill in your own unique bucket
name and your IP (`x.x.x.x/32`, e.g. from `curl ifconfig.me`).

## Safety notes

- Terraform **state files must never be committed** — the repo `.gitignore`
  covers `.terraform/`, `*.tfstate*`, `*.tfplan`, `crash.log`.
- `terraform.tfvars` is tracked only to satisfy the required filename and
  contains placeholders. For real runs use an ignored local `-var-file`; never
  commit credentials or your personal IP.
- **The EC2 instance has no application bootstrap** — this project only
  provisions infrastructure. Nothing listens on port 8000 until you deploy
  and start an app on the instance yourself.

## Submission summary

Terraform project demonstrating providers, variables, data source (SSM AMI),
VPC + subnet + IGW + security group + EC2 + private S3, and outputs.
**Not applied** — `init`/`validate`/`plan`/`apply` were not run against AWS;
no credentials or state are committed.
