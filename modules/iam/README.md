# IAM Module

This module creates IAM resources for EC2 instances with a least-privilege baseline.

## Purpose

- Create an EC2 IAM role with trust policy for `ec2.amazonaws.com`.
- Create and attach a custom least-privilege IAM policy for logs, metrics, and SSM parameter read.
- Attach `AmazonSSMManagedInstanceCore` for Session Manager connectivity.
- Create an EC2 instance profile for attaching the role to instances.
- Optionally create inline S3 write policy for backup uploads.

## What It Creates

- `aws_iam_role.ec2`
- `aws_iam_policy.ec2_least_privilege`
- `aws_iam_role_policy_attachment.ec2_least_privilege`
- `aws_iam_role_policy_attachment.ssm_core`
- `aws_iam_instance_profile.ec2`
- Optional:
  - `aws_iam_role_policy.backup_s3_write` (only when `backup_bucket_arn` is set)

## Behavior

- Base least-privilege policy includes:
  - `logs:CreateLogGroup`
  - `logs:CreateLogStream`
  - `logs:PutLogEvents`
  - `cloudwatch:PutMetricData`
  - `ssm:GetParameter`
  - `ssm:GetParameters`
- If `backup_bucket_arn = null`, backup S3 policy is not created.
- If `backup_bucket_arn` is set, module grants:
  - bucket list/location on the backup bucket
  - object write permissions under `backup_bucket_prefix/*`

## Inputs

- `project_name` (`string`): project name used in IAM naming.
- `environment` (`string`): environment name (`dev` or `prod`).
- `tags` (`map(string)`, default `{}`): additional tags.
- `backup_bucket_arn` (`string`, default `null`): optional backup bucket ARN.
- `backup_bucket_prefix` (`string`, default `"monitoring-stack"`): backup object key prefix.

## Tagging

The module applies base tags:

- `Project = var.project_name`
- `Environment = var.environment`
- `ManagedBy = terraform`

Additional `var.tags` are merged in.

## Outputs

- `ec2_role_name`: IAM role name used by EC2 instances.
- `ec2_role_arn`: IAM role ARN used by EC2 instances.
- `instance_profile_name`: IAM instance profile name for EC2.
- `instance_profile_arn`: IAM instance profile ARN for EC2.

## Example

```hcl
module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  # Optional: enable S3 backup write permissions
  backup_bucket_arn    = "arn:aws:s3:::secure-baseline-backups"
  backup_bucket_prefix = "monitoring-stack"
}
```
