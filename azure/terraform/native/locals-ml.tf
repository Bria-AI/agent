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
}