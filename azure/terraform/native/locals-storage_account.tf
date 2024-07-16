locals {
  model_container_name  = "model"

  image_containers = var.image_storage_account_container_name == null ? [
    {
      name = var.images_container_name
    }
  ] : []

  container_indices = flatten([
  for i in range(length(data.azurerm_storage_containers.container)) : [
    for j, container in data.azurerm_storage_containers.container[i].containers : j
    if container.name == var.images_container_name
  ]])

  container_index = length(local.container_indices) > 0 ? local.container_indices[0] : null
  matched_container_name = local.container_index != null ? data.azurerm_storage_containers.container[0].containers[local.container_index].name : null

  image_uploader_storage_account_count = var.images_storage_account_name == null ? 1 : 0
  use_custom_storage_account = var.images_storage_account_name == null ? false : true
  use_custom_container = var.image_storage_account_container_name == null ? false : true
}