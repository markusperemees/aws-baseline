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
