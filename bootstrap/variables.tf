variable "project_name" {
  description = "Project name prefix used for bootstrap resource names"
  type        = string
  default     = "secure-baseline"

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{1,28}[a-z0-9])$", var.project_name))
    error_message = "project_name must be 3-30 chars, use lowercase letters/numbers/hyphens, and cannot start or end with a hyphen."
  }

  validation {
    condition     = length(var.project_name) <= (63 - 22 - length(var.aws_region))
    error_message = "project_name is too long for the generated S3 bucket name with this aws_region. Keep project_name shorter so '<project>-tfstate-<account-id>-<region>' stays within 63 characters."
  }
}

variable "aws_region" {
  description = "AWS region where bootstrap resources are created"
  type        = string
  default     = "eu-north-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must look like eu-north-1 or us-east-1."
  }
}

variable "noncurrent_version_retention_days" {
  description = "Days to keep noncurrent S3 object versions in the Terraform state bucket"
  type        = number
  default     = 60

  validation {
    condition     = var.noncurrent_version_retention_days >= 30 && var.noncurrent_version_retention_days <= 90
    error_message = "noncurrent_version_retention_days must be between 30 and 90."
  }
}
