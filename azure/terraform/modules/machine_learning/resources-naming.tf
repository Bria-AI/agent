resource "azurecaf_name" "azurerm_machine_learning_workspace" {
  name          = var.stack
  resource_type = "azurerm_machine_learning_workspace"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "ml"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

#resource "azurecaf_name" "azurerm_machine_learning_compute_cluster" {
#  for_each = var.compute_cluster_map
#  name          = var.stack
#  resource_type = "azurerm_machine_learning_compute_cluster"
#  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
#  suffixes      = compact([var.client_name, var.location_short, var.environment, each.value.name, var.use_caf_naming ? "" : "mlcc"])
#  use_slug      = var.use_caf_naming
#  clean_input   = true
#  separator     = "-"
#}

resource "azurecaf_name" "application_insights" {
  name          = var.stack
  resource_type = "azurerm_application_insights"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, "ml", var.use_caf_naming ? "" : "ai"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}