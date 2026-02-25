output "app_log_group_name" {
  description = "CloudWatch log group name for application logs"
  value       = aws_cloudwatch_log_group.app.name
}

output "system_log_group_name" {
  description = "CloudWatch log group name for system logs"
  value       = aws_cloudwatch_log_group.system.name
}

output "high_cpu_alarm_names" {
  description = "List of high CPU CloudWatch alarm names for app instances"
  value       = [for idx in range(length(var.app_instance_ids)) : aws_cloudwatch_metric_alarm.high_cpu[tostring(idx)].alarm_name]
}

output "status_check_alarm_names" {
  description = "List of status check CloudWatch alarm names for app instances"
  value       = [for idx in range(length(var.app_instance_ids)) : aws_cloudwatch_metric_alarm.status_check_failed[tostring(idx)].alarm_name]
}

output "alarm_sns_topic_arn" {
  description = "SNS topic ARN for alarm notifications (null when alarm_email is empty)"
  value       = local.create_notifications ? aws_sns_topic.alarms[0].arn : null
}
