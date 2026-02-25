output "bastion_instance_id" {
  description = "EC2 instance ID of the bastion host"
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value = aws_instance.bastion.public_ip
}

output "app_instance_ids" {
  description = "List of EC2 instance IDs for app instances"
  value = aws_instance.app[*].id
}

output "app_private_ips" {
  description = "List of private IP addresses for app instances"
  value = aws_instance.app[*].private_ip
}
