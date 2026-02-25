# ALB Module

This module creates an internet-facing Application Load Balancer for app instances.

## Purpose

- Expose app instances through a single public endpoint.
- Route HTTP traffic from ALB to app instances on configurable app port.
- Provide health checks and target registration for EC2 instances.

## What It Creates

- `aws_lb.app`
- `aws_lb_target_group.app`
- `aws_lb_listener.http`
- `aws_lb_target_group_attachment.app` (count-based)

## Behavior

- ALB is public (`internal = false`) and deployed in `public_subnet_ids`.
- ALB security group is provided by `alb_sg_id`.
- Listener runs on port `80` (HTTP) and forwards to app target group.
- Target group uses `target_type = "instance"` and app port `app_port`.
- Health checks use:
  - `path = health_check_path`
  - `matcher = health_check_matcher`
- Every ID in `app_instance_ids` is attached to target group.

## Inputs

- `project_name` (`string`): project name used in naming and tags.
- `environment` (`string`): environment name (`dev` or `prod`).
- `tags` (`map(string)`, default `{}`): additional tags.
- `vpc_id` (`string`): VPC ID for target group.
- `public_subnet_ids` (`list(string)`): public subnet IDs for ALB.
- `alb_sg_id` (`string`): security group ID for ALB.
- `app_instance_ids` (`list(string)`): app EC2 instance IDs for registration.
- `app_port` (`number`, default `8080`): app target port.
- `health_check_path` (`string`, default `"/"`): health check HTTP path.
- `health_check_matcher` (`string`, default `"200-399"`): accepted health check status codes.

## Tagging

The module always applies base tags:

- `Project = var.project_name`
- `Environment = var.environment`
- `ManagedBy = terraform`

Additional `var.tags` are merged in.

## Outputs

- `alb_id`: Application Load Balancer ID.
- `alb_arn`: Application Load Balancer ARN.
- `alb_dns_name`: ALB DNS name.
- `alb_zone_id`: ALB hosted zone ID.
- `target_group_arn`: target group ARN.
- `target_group_name`: target group name.
- `http_listener_arn`: HTTP listener ARN.

## Example

```hcl
module "alb" {
  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  app_instance_ids  = module.ec2.app_instance_ids
}
```
