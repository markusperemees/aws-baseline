# Security Groups Module

This module creates security groups for the baseline network:

- Bastion security group (`sg-bastion`)
- ALB security group (`sg-alb`)
- Application security group (`sg-app`)
- Internal security group (`sg-internal`)

## Rules

- Bastion SG:
  - Inbound: SSH `22/tcp` only from `bastion_ssh_cidr`
  - Outbound: allow all
- ALB SG:
  - Inbound: HTTP `80/tcp` and HTTPS `443/tcp` from internet
  - Outbound: allow all
- App SG:
  - Inbound: app traffic `8080/tcp` only from ALB SG
  - Inbound: SSH `22/tcp` from Bastion SG
  - Outbound: allow all
- Internal SG:
  - Inbound: all traffic from `vpc_cidr`
  - Outbound: allow all

## Inputs

- `project_name` (`string`): project name used for naming and tags.
- `environment` (`string`): environment name (`dev` or `prod`).
- `vpc_id` (`string`): target VPC ID where SGs are created.
- `vpc_cidr` (`string`): VPC CIDR for internal SG ingress.
- `bastion_ssh_cidr` (`string`): your public IP in CIDR format, typically `/32`.
- `tags` (`map(string)`, default `{}`): additional tags.

## Tagging

The module always applies:

- `Project = var.project_name`
- `Environment = var.environment`
- `ManagedBy = terraform`

Additional `var.tags` are merged in.

## Outputs

- `bastion_sg_id`: security group ID for Bastion.
- `alb_sg_id`: security group ID for ALB.
- `app_sg_id`: security group ID for app instances.
- `internal_sg_id`: security group ID for internal VPC traffic.

## Example

```hcl
module "security_groups" {
  source = "../../modules/security-groups"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = var.vpc_cidr
  bastion_ssh_cidr = var.bastion_ssh_cidr
  tags             = var.tags
}
```
