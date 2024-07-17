locals {
  ml_compute_cluster_name = "bria"
  model_datastore_name    = "bria_model_blob_ds"
  ml_online_endpoint_name = join("-", [
    "mlrte",
    var.stack,
    random_string.identifier.result,
    module.azure_region.location_short,
    var.environment,
    random_string.ml_batch_endpoint_identifier.result
  ])
  ml_online_endpoint_deployment_name = join("-", [
    "mlrted",
    var.stack,
    random_string.identifier.result,
    module.azure_region.location_short,
    var.environment,
    random_string.ml_batch_endpoint_identifier.result
  ])

  ml_model_name = "bria-embedding-model"

  ml_rest_api_version = "2023-10-01"

  ml_default_datastore_regex = "azureml-blobstore"

    ml_default_datastore_container_name = element([for name in data.azurerm_storage_containers.ml_default_data_store_container.containers.*.name : name
    if replace(name, local.ml_default_datastore_regex , "") != name], 0)
}