resource "azurerm_machine_learning_datastore_blobstorage" "datastore" {
  for_each             = var.datastore_blob_storage_map
  name                 = coalesce(each.value.custom_name, each.value.name)
  storage_container_id = each.value.storage_container_id
  workspace_id         = azurerm_machine_learning_workspace.workspace.id

  account_key             = try(each.value.account_key, null)
  shared_access_signature = try(each.value.shared_access_signature, null)

  description = try(each.value.description, null)
  is_default  = try(each.value.is_default, false)

  service_data_auth_identity = try(each.value.service_data_auth_identity, "None")

  tags = merge(
    local.default_tags,
    var.extra_tags,
    each.value.tags
  )

}