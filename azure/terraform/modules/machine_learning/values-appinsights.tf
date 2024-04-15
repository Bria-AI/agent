variable "application_insights_created" {
  description = "Should the module create the application insight"
  type        = bool
  default     = true
}

variable "application_insights_id" {
  description = "(Required) The ID of the Application Insights associated with this Machine Learning Workspace. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "application_insights_type" {
  description = "Application type for Application Insights resource"
  type        = string
  default     = "web"
}