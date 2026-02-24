# VPC Module

This module creates the core network layer for the project:

- `aws_vpc`
- `aws_internet_gateway`
- Public and private subnets (from input maps)
- Public and private route tables
- Route table associations
- Optional NAT Gateway and Elastic IP

## Behavior

- Public route table always has `0.0.0.0/0 -> IGW`.
- Private route table has no internet egress by default.
- If `enable_nat_gateway = true`, the module creates:
  - one NAT Gateway
  - one Elastic IP
  - `0.0.0.0/0` route in the private route table via NAT
- NAT is placed into the first public subnet key in sorted order for deterministic behavior.

## Inputs

- `project_name` (`string`): project name used in resource names and tags.
- `environment` (`string`): `dev` or `prod`.
- `vpc_cidr` (`string`, default `10.0.0.0/16`): VPC CIDR block.
- `enable_nat_gateway` (`bool`, default `false`): enable private subnet internet egress via NAT.
- `public_subnets` (`map(object({ cidr = string, az = string }))`):
  default:
  - `public-a = 10.0.1.0/24 (eu-north-1a)`
  - `public-b = 10.0.2.0/24 (eu-north-1b)`
- `private_subnets` (`map(object({ cidr = string, az = string }))`):
  default:
  - `private-a = 10.0.10.0/24 (eu-north-1a)`
  - `private-b = 10.0.11.0/24 (eu-north-1b)`
- `tags` (`map(string)`, default `{}`): additional tags.

## Tagging

The module always applies base tags:

- `Project = var.project_name`
- `Environment = var.environment`
- `ManagedBy = terraform`

Additional `var.tags` are merged in for extra non-conflicting tags.

## Outputs

- `vpc_id`: VPC ID.
- `public_subnet_ids`: list of public subnet IDs.
- `private_subnet_ids`: list of private subnet IDs.
- `nat_gateway_id`: NAT Gateway ID when enabled, otherwise `null`.

## Example

```hcl
module "vpc" {
  source      = "../../modules/vpc"
  project_name = "secure-baseline"
  environment  = "dev"
  vpc_cidr     = "10.0.0.0/16"

  enable_nat_gateway = false

  public_subnets = {
    public-a = { cidr = "10.0.1.0/24", az = "eu-north-1a" }
    public-b = { cidr = "10.0.2.0/24", az = "eu-north-1b" }
  }

  private_subnets = {
    private-a = { cidr = "10.0.10.0/24", az = "eu-north-1a" }
    private-b = { cidr = "10.0.11.0/24", az = "eu-north-1b" }
  }

  tags = {
    Owner = "platform-team"
  }
}
```
