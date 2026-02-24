# Dev Environment

This directory contains Terraform configuration for the `dev` environment.

## Files

- `main.tf`: root module wiring (currently VPC module).
- `variables.tf`: input variable definitions and validation.
- `terraform.tfvars.example`: example values for local `terraform.tfvars`.
- `backend.tf`: remote state backend configuration (S3 + DynamoDB lock).
- `outputs.tf`: environment outputs.

## Usage

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
terraform init -reconfigure
terraform validate
terraform plan
terraform apply
```
