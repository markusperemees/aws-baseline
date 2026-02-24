output "tf_state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "tf_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  value       = aws_dynamodb_table.tf_lock.name
}

output "aws_region" {
  description = "AWS region where bootstrap resources were created"
  value       = var.aws_region
}

output "backend_s3_snippet" {
  description = "Copy-paste backend block for environments/<env>/backend.tf"
  value       = <<EOT
terraform {
  backend "s3" {
    bucket         = "${aws_s3_bucket.tf_state.bucket}"
    key            = "${var.project_name}/<environment>/terraform.tfstate"
    region         = "${var.aws_region}"
    encrypt        = true
    dynamodb_table = "${aws_dynamodb_table.tf_lock.name}"
  }
}
EOT
}
