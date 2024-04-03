resource "azurerm_federated_identity_credential" "msi" {
  for_each = var.federate_identity_map

  name                = coalesce(each.value.custom_name, azurecaf_name.azurerm_federated_identity_credential[each.key].result)
  resource_group_name = var.resource_group_name
  audience            = each.value.audience
  issuer              = each.value.issuer
  parent_id           = azurerm_user_assigned_identity.main.id
  subject             = each.value.subject
}
