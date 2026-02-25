# Observability Module

This module creates baseline CloudWatch observability resources for app instances.

## Purpose

- Create CloudWatch log groups for app and system logs.
- Create high CPU alarms for each app instance.
- Create EC2 status check alarms for each app instance.
- Optionally send alarm notifications to an email address through SNS.

## What It Creates

- `aws_cloudwatch_log_group.app`
- `aws_cloudwatch_log_group.system`
- `aws_cloudwatch_metric_alarm.high_cpu` (for each app instance)
- `aws_cloudwatch_metric_alarm.status_check_failed` (for each app instance)
- Optional:
  - `aws_sns_topic.alarms` (when `alarm_email` is provided)
  - `aws_sns_topic_subscription.email` (when `alarm_email` is provided)

## Behavior

- Log groups are named:
  - `/<project_name>/<environment>/app`
  - `/<project_name>/<environment>/system`
- High CPU alarm watches `AWS/EC2 -> CPUUtilization`.
- Status alarm watches `AWS/EC2 -> StatusCheckFailed`.
- If `alarm_email` is empty, SNS topic/subscription are not created.
- If `alarm_email` is set, all alarms use SNS topic for `alarm_actions` and `ok_actions`.

## Inputs

- `project_name` (`string`): project name used in naming and tags.
- `environment` (`string`): environment name (`dev` or `prod`).
- `tags` (`map(string)`, default `{}`): additional tags.
- `app_instance_ids` (`list(string)`): app EC2 instance IDs to monitor.
- `log_retention_days` (`number`, default `7`): CloudWatch log retention.
- `alarm_email` (`string`, default `""`): optional alarm notification email.
- `cpu_threshold_percent` (`number`, default `80`): CPU threshold for alarms.
- `cpu_period_seconds` (`number`, default `300`): period for CPU alarms.
- `cpu_evaluation_periods` (`number`, default `1`): evaluation periods for CPU alarms.
- `status_check_period_seconds` (`number`, default `60`): period for status check alarms.
- `status_check_evaluation_periods` (`number`, default `2`): evaluation periods for status check alarms.

## Tagging

The module always applies base tags:

- `Project = var.project_name`
- `Environment = var.environment`
- `ManagedBy = terraform`

Additional `var.tags` are merged in.

## Outputs

- `app_log_group_name`: app log group name.
- `system_log_group_name`: system log group name.
- `high_cpu_alarm_names`: high CPU alarm names for app instances.
- `status_check_alarm_names`: status check alarm names for app instances.
- `alarm_sns_topic_arn`: SNS topic ARN for notifications, or `null`.

## Example

```hcl
module "observability" {
  source = "../../modules/observability"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  app_instance_ids = module.ec2.app_instance_ids

  log_retention_days             = 7
  alarm_email                    = ""
  cpu_threshold_percent          = 80
  cpu_period_seconds             = 300
  cpu_evaluation_periods         = 1
  status_check_period_seconds    = 60
  status_check_evaluation_periods = 2
}
```
