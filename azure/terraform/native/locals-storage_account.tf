locals {
  model_container_name = "model"


  use_custom_resource_group  = var.image_storage_account_resource_group_name == null ? false : true
  use_custom_storage_account = var.images_storage_account_name == null ? false : true

  image_containers = [
    {
      name = var.images_container_name
    }
  ]

  image_container_exist = contains(
    try(data.azurerm_storage_containers.image_storage_account_containers.0.containers.*.name, []),
    var.images_container_name
  )
}