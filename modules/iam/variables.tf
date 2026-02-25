variable "project_name" {
  description = "Project name for the AWS resources"
  type        = string
}

variable "environment" {
  description = "Environment: dev or prod"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

variable "backup_bucket_arn" {
  description = "Optional S3 bucket ARN for backup uploads."
  type        = string
  default     = null

  validation {
    condition = var.backup_bucket_arn == null || (
      length(trimspace(var.backup_bucket_arn)) > 0 &&
      can(regex("^arn:(aws|aws-us-gov|aws-cn):s3:::[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", trimspace(var.backup_bucket_arn)))
    )
    error_message = "backup_bucket_arn must be null or a valid S3 bucket ARN (e.g., arn:aws:s3:::my-backup-bucket)."
  }
}

variable "backup_bucket_prefix" {
  description = "S3 prefix for backup objects."
  type        = string
  default     = "monitoring-stack"

  validation {
    condition     = length(trim(trimspace(var.backup_bucket_prefix), "/")) > 0
    error_message = "backup_bucket_prefix must not be empty or only '/'."
  }
}
