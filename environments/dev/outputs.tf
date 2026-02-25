output "vpc_id" {
  description = "VPC ID for the dev environment"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the dev environment"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the dev environment"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID for the dev environment (null when disabled)"
  value       = module.vpc.nat_gateway_id
}

output "bastion_sg_id" {
  description = "Security group ID for Bastion host"
  value       = module.security_groups.bastion_sg_id
}

output "alb_sg_id" {
  description = "Security group ID for Application Load Balancer"
  value       = module.security_groups.alb_sg_id
}

output "app_sg_id" {
  description = "Security group ID for application instances"
  value       = module.security_groups.app_sg_id
}

output "internal_sg_id" {
  description = "Security group ID for internal VPC traffic"
  value       = module.security_groups.internal_sg_id
}

output "ec2_role_name" {
  description = "IAM role name used by EC2 instances in the dev environment"
  value       = module.iam.ec2_role_name
}

output "ec2_role_arn" {
  description = "IAM role ARN used by EC2 instances in the dev environment"
  value       = module.iam.ec2_role_arn
}

output "instance_profile_name" {
  description = "IAM instance profile name used by EC2 instances in the dev environment"
  value       = module.iam.instance_profile_name
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN used by EC2 instances in the dev environment"
  value       = module.iam.instance_profile_arn
}

output "bastion_instance_id" {
  description = "EC2 instance ID of the bastion host in dev"
  value       = module.ec2.bastion_instance_id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host in dev"
  value       = module.ec2.bastion_public_ip
}

output "app_instance_ids" {
  description = "List of app EC2 instance IDs in dev"
  value       = module.ec2.app_instance_ids
}

output "app_private_ips" {
  description = "List of app EC2 private IP addresses in dev"
  value       = module.ec2.app_private_ips
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer in dev"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer in dev"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "Target group ARN used by the ALB in dev"
  value       = module.alb.target_group_arn
}

output "http_listener_arn" {
  description = "HTTP listener ARN (port 80) for the ALB in dev"
  value       = module.alb.http_listener_arn
}

output "app_log_group_name" {
  description = "CloudWatch log group name for app logs in dev"
  value       = module.observability.app_log_group_name
}

output "system_log_group_name" {
  description = "CloudWatch log group name for system logs in dev"
  value       = module.observability.system_log_group_name
}

output "high_cpu_alarm_names" {
  description = "List of high CPU alarm names for app instances in dev"
  value       = module.observability.high_cpu_alarm_names
}

output "status_check_alarm_names" {
  description = "List of status check alarm names for app instances in dev"
  value       = module.observability.status_check_alarm_names
}

output "alarm_sns_topic_arn" {
  description = "SNS topic ARN for alarm notifications in dev (null when alarm_email is empty)"
  value       = module.observability.alarm_sns_topic_arn
}
