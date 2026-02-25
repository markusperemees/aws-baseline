output "ec2_role_name" {
  description = "IAM role name used by EC2 instances"
  value       = aws_iam_role.ec2.name
}

output "ec2_role_arn" {
  description = "IAM role ARN used by EC2 instances"
  value       = aws_iam_role.ec2.arn
}

output "instance_profile_name" {
  description = "IAM instance profile name attached to EC2 instances"
  value       = aws_iam_instance_profile.ec2.name
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN attached to EC2 instances"
  value       = aws_iam_instance_profile.ec2.arn
}
