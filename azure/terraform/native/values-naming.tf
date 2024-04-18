variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "custom_rg_name" {
  description = "Optional custom resource group name"
  type        = string
  default     = ""
}

variable "custom_log_analytics" {
  description = "Optional custom rlog analytics name"
  type        = string
  default     = ""
}