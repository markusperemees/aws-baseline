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

variable "public_subnet_id" {
  description = "ID of the public subnet where the bastion host is deployed."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]+$", var.public_subnet_id))
    error_message = "public_subnet_id must look like a valid subnet ID (e.g., subnet-1234abcd)."
  }
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where app instances are distributed."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "private_subnet_ids must include at least one subnet ID."
  }

  validation {
    condition     = alltrue([for subnet_id in var.private_subnet_ids : can(regex("^subnet-[0-9a-f]+$", subnet_id))])
    error_message = "Each private_subnet_ids item must look like a valid subnet ID (e.g., subnet-1234abcd)."
  }
}

variable "bastion_sg_id" {
  description = "Security group ID attached to the bastion instance."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]+$", var.bastion_sg_id))
    error_message = "bastion_sg_id must look like a valid security group ID (e.g., sg-1234abcd)."
  }
}

variable "app_sg_id" {
  description = "Security group ID attached to app instances."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]+$", var.app_sg_id))
    error_message = "app_sg_id must look like a valid security group ID (e.g., sg-1234abcd)."
  }
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name attached to EC2 instances."
  type        = string

  validation {
    condition     = length(trimspace(var.iam_instance_profile_name)) > 0
    error_message = "iam_instance_profile_name must not be empty."
  }
}

variable "key_name" {
  description = "Existing AWS key pair name (optional, null if not used)"
  type        = string
  default     = null

  validation {
    condition     = var.key_name == null || length(trimspace(var.key_name)) > 0
    error_message = "key_name must be null or a non-empty key pair name."
  }
}

variable "ami_id" {
  description = "Optional override for AMI."
  type        = string
  default     = null

  validation {
    condition     = var.ami_id == null || can(regex("^ami-[0-9a-f]+$", var.ami_id))
    error_message = "ami_id must be null or look like a valid AMI ID (e.g., ami-1234abcd)."
  }
}

variable "bastion_instance_type" {
  description = "EC2 instance type for the bastion host."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*\\.[a-z0-9]+$", var.bastion_instance_type))
    error_message = "bastion_instance_type must look like a valid EC2 type (e.g., t3.micro)."
  }
}

variable "app_instance_type" {
  description = "EC2 instance type for app servers."
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*\\.[a-z0-9]+$", var.app_instance_type))
    error_message = "app_instance_type must look like a valid EC2 type (e.g., t3.micro)."
  }
}

variable "app_instance_count" {
  description = "Number of app instances to launch in the private subnet."
  type        = number
  default     = 3

  validation {
    condition     = var.app_instance_count == floor(var.app_instance_count)
    error_message = "app_instance_count must be a whole number."
  }

  validation {
    condition     = var.app_instance_count >= 1 && var.app_instance_count <= 20
    error_message = "app_instance_count must be between 1 and 20."
  }
}
