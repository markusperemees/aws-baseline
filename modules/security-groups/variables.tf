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

variable "vpc_id" {
  description = "ID of the VPC to use."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must look like a valid VPC ID (e.g., vpc-1234abcd)."
  }
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC used for internal security group rules."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid CIDR block (e.g., 10.0.0.0/16)."
  }
}

variable "bastion_ssh_cidr" {
  description = "CIDR block allowed to access Bastion SSH (your public IP/32)."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.bastion_ssh_cidr))
    error_message = "bastion_ssh_cidr must be a valid CIDR block (e.g., 203.0.113.10/32)."
  }
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
