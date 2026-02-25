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

variable "app_instance_ids" {
  description = "List of app EC2 instance IDs monitored by CloudWatch alarms."
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

variable "log_retention_days" {
  description = "CloudWatch Logs retention in days."
  type        = number
  default     = 7

  validation {
    condition     = var.log_retention_days == floor(var.log_retention_days)
    error_message = "log_retention_days must be a whole number."
  }

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365,
      400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.log_retention_days)
    error_message = "log_retention_days must be one of AWS allowed retention values."
  }
}

variable "alarm_email" {
  description = "Optional email address for CloudWatch alarm notifications."
  type        = string
  default     = ""

  validation {
    condition = trimspace(var.alarm_email) == "" || can(
      regex("^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\\.[A-Za-z0-9-]+)+$", trimspace(var.alarm_email))
    )
    error_message = "alarm_email must be empty or a valid email address."
  }
}

variable "cpu_threshold_percent" {
  description = "CPU utilization threshold for high CPU alarms."
  type        = number
  default     = 80

  validation {
    condition     = var.cpu_threshold_percent > 0 && var.cpu_threshold_percent <= 100
    error_message = "cpu_threshold_percent must be between 0 and 100."
  }
}

variable "cpu_period_seconds" {
  description = "CloudWatch period in seconds for high CPU alarms."
  type        = number
  default     = 300

  validation {
    condition     = var.cpu_period_seconds == floor(var.cpu_period_seconds)
    error_message = "cpu_period_seconds must be a whole number."
  }

  validation {
    condition     = var.cpu_period_seconds >= 60 && var.cpu_period_seconds <= 86400 && var.cpu_period_seconds % 60 == 0
    error_message = "cpu_period_seconds must be between 60 and 86400 and divisible by 60."
  }
}

variable "cpu_evaluation_periods" {
  description = "Number of periods evaluated for high CPU alarms."
  type        = number
  default     = 1

  validation {
    condition     = var.cpu_evaluation_periods == floor(var.cpu_evaluation_periods)
    error_message = "cpu_evaluation_periods must be a whole number."
  }

  validation {
    condition     = var.cpu_evaluation_periods >= 1 && var.cpu_evaluation_periods <= 10
    error_message = "cpu_evaluation_periods must be between 1 and 10."
  }
}

variable "status_check_period_seconds" {
  description = "CloudWatch period in seconds for instance status check alarms."
  type        = number
  default     = 60

  validation {
    condition     = var.status_check_period_seconds == floor(var.status_check_period_seconds)
    error_message = "status_check_period_seconds must be a whole number."
  }

  validation {
    condition     = var.status_check_period_seconds >= 60 && var.status_check_period_seconds <= 86400 && var.status_check_period_seconds % 60 == 0
    error_message = "status_check_period_seconds must be between 60 and 86400 and divisible by 60."
  }
}

variable "status_check_evaluation_periods" {
  description = "Number of periods evaluated for instance status check alarms."
  type        = number
  default     = 2

  validation {
    condition     = var.status_check_evaluation_periods == floor(var.status_check_evaluation_periods)
    error_message = "status_check_evaluation_periods must be a whole number."
  }

  validation {
    condition     = var.status_check_evaluation_periods >= 1 && var.status_check_evaluation_periods <= 10
    error_message = "status_check_evaluation_periods must be between 1 and 10."
  }
}
