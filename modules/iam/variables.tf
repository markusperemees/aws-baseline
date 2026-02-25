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
}

variable "backup_bucket_prefix" {
  description = "S3 prefix for backup objects."
  type        = string
  default     = "monitoring-stack"

  validation {
    condition     = length(trimspace(var.backup_bucket_prefix)) > 0
    error_message = "backup_bucket_prefix must not be empty."
  }
}