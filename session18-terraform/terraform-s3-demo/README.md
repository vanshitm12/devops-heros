# Terraform S3 Demo

Creates a **private** AWS S3 bucket with versioning, AES256 server-side
encryption and all public access blocked. `force_destroy = false` — Terraform
refuses to destroy a non-empty bucket.

> Set `bucket_name` in `terraform.tfvars` (currently a literal
> `REPLACE_WITH_UNIQUE_BUCKET_NAME` placeholder) before running. AWS
> credentials come from your local environment (`AWS_PROFILE` /
> `aws configure`) — never commit them.

## Workflow

```bash
terraform init       # download the AWS provider (~> 5.0)
terraform fmt        # format the .tf files
terraform validate   # syntax/config check
terraform plan       # preview: 4 resources to create
terraform apply      # create the bucket (type 'yes')
terraform show       # inspect recorded state
terraform output     # bucket_id / bucket_arn
terraform destroy    # tear down (only on your own sandbox account)
```

## Evidence

Paste your own `plan`/`apply`/`output` results here if you run this against
your own AWS account. Do not run `apply`/`destroy` on shared accounts.

## Safety notes

- Terraform **state files must never be committed** — the repo `.gitignore`
  covers `.terraform/`, `*.tfstate*`, `*.tfplan`, `crash.log`.
- `terraform.tfvars` is tracked here only because the assignment requires the
  filename. Keep the placeholder values in Git; for real runs copy it to an
  ignored local file (e.g. `local.tfvars` + `-var-file`) and never commit
  real credentials or your personal IP.
