# EC2 Module

This module creates a simple compute layer for the baseline environment:

- one Bastion EC2 instance in a public subnet
- one or more App EC2 instances in private subnets

## Purpose

- Launch a Bastion host for administrative access patterns.
- Launch App instances with IAM instance profile attached.
- Reuse a shared user-data template with role-specific behavior.

## What It Creates

- `data.aws_ami.al2023` (Amazon Linux 2023 lookup, most recent)
- `aws_instance.bastion`
- `aws_instance.app` (count-based)

## Behavior

- If `ami_id` is `null`, module uses the latest Amazon Linux 2023 AMI.
- Bastion is always launched into `public_subnet_id` with public IP enabled.
- App instances are launched across `private_subnet_ids` in round-robin order:
  - `private_subnet_ids[count.index % length(private_subnet_ids)]`
- Bastion uses `bastion_sg_id`; app instances use `app_sg_id`.
- IAM instance profile is attached to both bastion and app instances.
- `key_name` is optional; set `null` to skip SSH key pair attachment.
- User data template receives role:
  - `bastion` for bastion instance
  - `app` for app instances

## Inputs

- `project_name` (`string`): project name used in naming and tags.
- `environment` (`string`): environment name (`dev` or `prod`).
- `tags` (`map(string)`, default `{}`): additional tags.
- `public_subnet_id` (`string`): subnet ID for bastion.
- `private_subnet_ids` (`list(string)`): subnet IDs for app placement.
- `bastion_sg_id` (`string`): security group ID for bastion.
- `app_sg_id` (`string`): security group ID for app instances.
- `iam_instance_profile_name` (`string`): IAM instance profile attached to instances.
- `key_name` (`string`, default `null`): optional EC2 key pair name.
- `ami_id` (`string`, default `null`): optional AMI override.
- `bastion_instance_type` (`string`, default `t3.micro`): bastion EC2 type.
- `app_instance_type` (`string`, default `t3.micro`): app EC2 type.
- `app_instance_count` (`number`, default `3`): number of app instances.

## Tagging

The module always applies base tags:

- `Project = var.project_name`
- `Environment = var.environment`
- `ManagedBy = terraform`

Additional `var.tags` are merged in.

## Outputs

- `bastion_instance_id`: EC2 instance ID of bastion.
- `bastion_public_ip`: public IP of bastion.
- `app_instance_ids`: list of app EC2 instance IDs.
- `app_private_ips`: list of app private IP addresses.

## Example

```hcl
module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  public_subnet_id      = module.vpc.public_subnet_ids[0]
  private_subnet_ids    = module.vpc.private_subnet_ids
  bastion_sg_id         = module.security_groups.bastion_sg_id
  app_sg_id             = module.security_groups.app_sg_id
  iam_instance_profile_name = module.iam.instance_profile_name

  key_name              = null
  ami_id                = null
  bastion_instance_type = "t3.micro"
  app_instance_type     = "t3.micro"
  app_instance_count    = 2
}
```
