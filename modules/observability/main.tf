locals {
  name_prefix = "${var.project_name}-${var.environment}"
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
  common_tags = merge(var.tags, local.default_tags)

  alarm_email_normalized = trimspace(var.alarm_email)
  create_notifications   = local.alarm_email_normalized != ""
  alarm_actions          = local.create_notifications ? [aws_sns_topic.alarms[0].arn] : []
  app_instances_by_index = { for idx, instance_id in var.app_instance_ids : tostring(idx) => instance_id }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.project_name}/${var.environment}/app"
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-logs"
  })
}

resource "aws_cloudwatch_log_group" "system" {
  name              = "/${var.project_name}/${var.environment}/system"
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-system-logs"
  })
}

resource "aws_sns_topic" "alarms" {
  count = local.create_notifications ? 1 : 0

  name = "${local.name_prefix}-alarms"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alarms"
  })
}

resource "aws_sns_topic_subscription" "email" {
  count = local.create_notifications ? 1 : 0

  topic_arn = aws_sns_topic.alarms[0].arn
  protocol  = "email"
  endpoint  = local.alarm_email_normalized
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  for_each = local.app_instances_by_index

  alarm_name          = "${local.name_prefix}-high-cpu-app-${tonumber(each.key) + 1}"
  alarm_description   = "High CPU utilization on app instance index ${tonumber(each.key) + 1}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_period_seconds
  statistic           = "Average"
  threshold           = var.cpu_threshold_percent
  treat_missing_data  = "missing"

  dimensions = {
    InstanceId = each.value
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  for_each = local.app_instances_by_index

  alarm_name          = "${local.name_prefix}-status-check-failed-app-${tonumber(each.key) + 1}"
  alarm_description   = "EC2 status check failed on app instance index ${tonumber(each.key) + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.status_check_evaluation_periods
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = var.status_check_period_seconds
  statistic           = "Maximum"
  threshold           = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = each.value
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.alarm_actions
}
