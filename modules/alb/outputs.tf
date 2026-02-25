output "alb_id" {
  description = "Application Load Balancer ID"
  value       = aws_lb.app.id
}

output "alb_arn" {
  description = "Application Load Balancer ARN"
  value       = aws_lb.app.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the Application Load Balancer"
  value       = aws_lb.app.zone_id
}

output "target_group_arn" {
  description = "Target group ARN used by the ALB listener"
  value       = aws_lb_target_group.app.arn
}

output "target_group_name" {
  description = "Target group name used by the ALB listener"
  value       = aws_lb_target_group.app.name
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener on port 80"
  value       = aws_lb_listener.http.arn
}
