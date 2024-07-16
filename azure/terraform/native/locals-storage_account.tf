locals {
  model_container_name = "model"


  use_custom_resource_group  = var.storage_account_resource_group_name == null ? false : true
  use_custom_storage_account = var.images_storage_account_name == null ? false : true
  use_custom_container       = var.images_container_name == null ? true : false

  image_containers = local.use_custom_container ? [] : [
    {
      name = var.images_container_name
    }
  ]
}