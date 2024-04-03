# General variables
variable "location" {
  description = "Azure region to use"
  type        = string
  default     = "South Central US"
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
  default     = "agent"
}

variable "environment" {
  description = "Project environment"
  type        = string
  default     = "prod"
}

variable "stack" {
  description = "Project stack name"
  type        = string
  default     = "bria"
}


