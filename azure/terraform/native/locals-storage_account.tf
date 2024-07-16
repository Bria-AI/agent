locals {
  model_container_name = "model"

  image_containers = [
    {
      name = var.images_container_name
    }
  ]

}