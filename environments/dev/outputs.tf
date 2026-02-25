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
