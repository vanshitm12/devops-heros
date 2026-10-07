# Session 18: Terraform & Infrastructure as Code

## Task 1: Terraform S3 demo

- [terraform-s3-demo/](terraform-s3-demo/) — `main.tf`, `variables.tf`,
  `outputs.tf`, `provider.tf`, `terraform.tfvars`,
  [README.md](terraform-s3-demo/README.md)
- Creates a private S3 bucket: AES256 encryption, versioning, full
  public-access block, `force_destroy = false`. `terraform.tfvars` holds
  placeholders (`REPLACE_WITH_UNIQUE_BUCKET_NAME`) — fill in for real runs.

## Task 2: AWS services research

- [aws-services/01-iam/README.md](aws-services/01-iam/README.md)
- [aws-services/02-ec2/README.md](aws-services/02-ec2/README.md)
- [aws-services/03-s3/README.md](aws-services/03-s3/README.md)
- [aws-services/04-vpc/README.md](aws-services/04-vpc/README.md)
- [aws-services/05-dynamodb-rds/README.md](aws-services/05-dynamodb-rds/README.md)

## Status

Documentation complete; **no `terraform apply`/`destroy` was run** — no AWS
account changes were made for this submission.
