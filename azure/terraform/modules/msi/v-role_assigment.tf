variable "enable_role_assignment" {
  type        = bool
  description = "Enable role assignment for the MSI"
  default     = false
}

variable "scope" {
  type        = string
  description = "The scope to assign the role"
  default     = null
}

variable "role_definition_name" {
  type        = string
  description = "Role definition name. if empty string you will have to put the role definition ID"
  default     = null
}
variable "role_definition_id" {
  type        = string
  description = "Role definition ID. if empty string you will have to put the role definition name"
  default     = null
}
variable "skip_service_principal_aad_check" {
  type        = bool
  description = "If the principal_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag. This argument is only valid if the principal_id is a Service Principal identity. If it is not a Service Principal identity it will cause the role assignment to fail"
  default     = false
}

variable "description" {
  type        = string
  description = "The description for the role assignment"
  default     = ""
}
