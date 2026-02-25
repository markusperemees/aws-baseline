output "bastion_sg_id" {
  description = "Security group ID for Bastion host"
  value       = aws_security_group.bastion.id
}

output "app_sg_id" {
  description = "Security group ID for application instances"
  value       = aws_security_group.app.id
}

output "internal_sg_id" {
  description = "Security group ID for internal VPC traffic"
  value       = aws_security_group.internal.id
}
