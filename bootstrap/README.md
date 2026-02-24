# Bootstrap Remote State

This directory creates the Terraform remote state foundation for the project.
Run it once before deploying environment infrastructure.

## Purpose

- Create an S3 bucket for Terraform state storage.
- Create a DynamoDB table for state locking.
- Output a ready-to-copy backend snippet for environment configs.

## What It Creates

- `aws_s3_bucket.tf_state`
- `aws_s3_bucket_versioning.tf_state`
- `aws_s3_bucket_lifecycle_configuration.tf_state`
- `aws_s3_bucket_server_side_encryption_configuration.tf_state`
- `aws_s3_bucket_public_access_block.tf_state`
- `aws_s3_bucket_policy.tf_state_enforce_tls` (deny non-TLS requests)
- `aws_dynamodb_table.tf_lock`

## Safety Controls

- `prevent_destroy` on S3 state bucket and DynamoDB lock table.
- S3 versioning enabled.
- Noncurrent object versions expire after `noncurrent_version_retention_days`.
- S3 server-side encryption enabled (`AES256`).
- Public access blocked on the state bucket.
- Bucket policy denies non-HTTPS (`aws:SecureTransport = false`).

## Usage

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

## Variables

- `project_name` (default: `secure-baseline`)
- `aws_region` (default: `eu-north-1`)
- `noncurrent_version_retention_days` (default: `60`)

## Outputs

```bash
terraform output tf_state_bucket_name
terraform output tf_lock_table_name
terraform output backend_s3_snippet
```

Use `backend_s3_snippet` in `environments/dev/backend.tf` (and other environment backends).
