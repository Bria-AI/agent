resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = local.msi_name
  tags                = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_role_assignment" "role_assignment" {
  count                            = var.enable_role_assignment ? 1 : 0
  principal_id                     = azurerm_user_assigned_identity.main.principal_id
  scope                            = var.scope
  role_definition_name             = var.role_definition_name
  role_definition_id               = var.role_definition_id
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}



