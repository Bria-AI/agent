locals {
  # Naming locals/constants
  name_prefix       = lower(var.name_prefix)
  name_suffix       = lower(var.name_suffix)
  clara_slug        = "msi"
  workspace_name    = coalesce(var.custom_ml_workspace_name, azurecaf_name.azurerm_machine_learning_workspace.result)
  app_insights_name = coalesce(var.application_insights_custom_name, azurecaf_name.application_insights.result)
}
