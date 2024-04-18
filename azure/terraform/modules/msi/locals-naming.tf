locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)
  clara_slug  = "msi"
  msi_name    = coalesce(var.custom_msi_name, azurecaf_name.msi.result)

  role_assignment_name = coalesce(var.custom_role_assignment_name, try(azurecaf_name.role_assignment.0.result, "role"))
}
