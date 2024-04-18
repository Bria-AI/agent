resource "azurecaf_name" "msi" {
  name          = var.stack
  resource_type = "azurerm_user_assigned_identity"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "identity"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "azurerm_federated_identity_credential" {

  for_each = var.federate_identity_map

  resource_type = "azurerm_federated_identity_credential"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, each.value.name, var.use_caf_naming ? "" : "fic"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"

}

resource "azurecaf_name" "role_assignment" {
  count = var.enable_role_assignment ? 1 : 0

  name          = var.stack
  resource_type = "azurerm_role_assignment"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "role-assignment"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}