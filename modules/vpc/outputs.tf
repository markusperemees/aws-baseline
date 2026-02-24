output "vpc_id" {
  description = "VPC ID created by the module"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for key in sort(keys(aws_subnet.public)) : aws_subnet.public[key].id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for key in sort(keys(aws_subnet.private)) : aws_subnet.private[key].id]
}

output "nat_gateway_id" {
  description = "NAT Gateway ID when enabled, otherwise null"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
}
