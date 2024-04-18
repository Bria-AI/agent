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

variable "custom_ml_workspace_name" {
  description = "Optional custom ml workspace name"
  type        = string
  default     = ""
}

variable "application_insights_custom_name" {
  description = "Name of the Application Insights, generated if not set."
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `custom_msi_name` or `custom_role_assignment_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}
