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

variable "aws_region" {
  description = "AWS region for dev environment resources."
  type        = string
  default     = "eu-north-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "aws_region must look like eu-north-1 or us-east-1."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block (e.g., 10.0.0.0/16)."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnet egress to the internet."
  type        = bool
  default     = false
}

variable "bastion_ssh_cidr" {
  description = "CIDR block for your public IP (used for Bastion SSH access)."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.bastion_ssh_cidr))
    error_message = "bastion_ssh_cidr must be a valid CIDR block (e.g., 203.0.113.10/32)."
  }
}

variable "key_name" {
  description = "Existing AWS key pair name for EC2 SSH access (optional)."
  type        = string
  default     = null

  validation {
    condition     = var.key_name == null || length(trimspace(var.key_name)) > 0
    error_message = "key_name must be null or a non-empty key pair name."
  }
}

variable "app_ami_id" {
  description = "Optional AMI override for app and bastion instances."
  type        = string
  default     = null

  validation {
    condition     = var.app_ami_id == null || can(regex("^ami-[0-9a-f]+$", var.app_ami_id))
    error_message = "app_ami_id must be null or look like a valid AMI ID (e.g., ami-1234abcd)."
  }
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*\\.[a-z0-9]+$", var.bastion_instance_type))
    error_message = "bastion_instance_type must look like a valid EC2 type (e.g., t3.micro)."
  }
}

variable "app_instance_type" {
  description = "EC2 instance type for app instances."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*\\.[a-z0-9]+$", var.app_instance_type))
    error_message = "app_instance_type must look like a valid EC2 type (e.g., t3.micro)."
  }
}

variable "app_instance_count" {
  description = "Number of app instances in private subnets."
  type        = number
  default     = 2

  validation {
    condition     = var.app_instance_count == floor(var.app_instance_count)
    error_message = "app_instance_count must be a whole number."
  }

  validation {
    condition     = var.app_instance_count >= 1 && var.app_instance_count <= 20
    error_message = "app_instance_count must be between 1 and 20."
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
  description = "Optional email address for alarm notifications."
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

variable "public_subnets" {
  description = "Public subnets keyed by name. Each item must include cidr and az."
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "public-a" = {
      cidr = "10.0.1.0/24"
      az   = "eu-north-1a"
    }
    "public-b" = {
      cidr = "10.0.2.0/24"
      az   = "eu-north-1b"
    }
  }

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "public_subnets must include at least two entries (for example public-a and public-b)."
  }

  validation {
    condition     = alltrue([for subnet in values(var.public_subnets) : can(cidrnetmask(subnet.cidr))])
    error_message = "Each public_subnets entry must have a valid CIDR (e.g., 10.0.1.0/24)."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.public_subnets) : can(regex("^[a-z]{2}-[a-z]+-\\d[a-z]$", subnet.az))
    ])
    error_message = "Each public_subnets entry must have a valid AZ (e.g., eu-west-1a)."
  }
}

variable "private_subnets" {
  description = "Private subnets keyed by name. Each item must include cidr and az."
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {
    "private-a" = {
      cidr = "10.0.10.0/24"
      az   = "eu-north-1a"
    }
    "private-b" = {
      cidr = "10.0.11.0/24"
      az   = "eu-north-1b"
    }
  }

  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "private_subnets must include at least two entries (for example private-a and private-b)."
  }

  validation {
    condition     = alltrue([for subnet in values(var.private_subnets) : can(cidrnetmask(subnet.cidr))])
    error_message = "Each private_subnets entry must have a valid CIDR (e.g., 10.0.10.0/24)."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.private_subnets) : can(regex("^[a-z]{2}-[a-z]+-\\d[a-z]$", subnet.az))
    ])
    error_message = "Each private_subnets entry must have a valid AZ (e.g., eu-west-1a)."
  }
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
