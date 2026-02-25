variable "project_name" {
  description = "Project name for the AWS resources"
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
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

variable "vpc_id" {
  description = "ID of the VPC where ALB and target group are created."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must look like a valid VPC ID (e.g., vpc-1234abcd)."
  }
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs used by the ALB."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "public_subnet_ids must include at least two subnet IDs."
  }

  validation {
    condition     = alltrue([for subnet_id in var.public_subnet_ids : can(regex("^subnet-[0-9a-f]+$", subnet_id))])
    error_message = "Each public_subnet_ids item must look like a valid subnet ID (e.g., subnet-1234abcd)."
  }
}

variable "alb_sg_id" {
  description = "Security group ID attached to the ALB."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]+$", var.alb_sg_id))
    error_message = "alb_sg_id must look like a valid security group ID (e.g., sg-1234abcd)."
  }
}

variable "app_instance_ids" {
  description = "List of app EC2 instance IDs to register in the target group."
  type        = list(string)

  validation {
    condition     = length(var.app_instance_ids) > 0
    error_message = "app_instance_ids must include at least one instance ID."
  }

  validation {
    condition     = alltrue([for instance_id in var.app_instance_ids : can(regex("^i-[0-9a-f]+$", instance_id))])
    error_message = "Each app_instance_ids item must look like a valid EC2 instance ID (e.g., i-1234abcd)."
  }
}

variable "app_port" {
  description = "Application port used by targets behind the ALB."
  type        = number
  default     = 8080

  validation {
    condition     = var.app_port == floor(var.app_port)
    error_message = "app_port must be a whole number."
  }

  validation {
    condition     = var.app_port >= 1 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "health_check_path" {
  description = "HTTP path used for ALB target health checks."
  type        = string
  default     = "/"

  validation {
    condition     = length(trimspace(var.health_check_path)) > 0 && startswith(var.health_check_path, "/")
    error_message = "health_check_path must be non-empty and start with '/'."
  }
}

variable "health_check_matcher" {
  description = "Expected HTTP status code or range for successful health checks."
  type        = string
  default     = "200-399"

  validation {
    condition     = can(regex("^[0-9]{3}(-[0-9]{3})?$", var.health_check_matcher))
    error_message = "health_check_matcher must be a status code or range (e.g., 200 or 200-399)."
  }
}
