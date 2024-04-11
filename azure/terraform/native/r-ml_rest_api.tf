resource "terraform_data" "replace_ml_rest_api_object" {
  input = {
    instanceType = var.ml_vm_size
  }
}

moved {
  from = terraform_data.ml_online_endpoint_deployment_replace
  to   = terraform_data.replace_ml_rest_api_object
}

# Create the model
resource "azapi_resource" "ml_model" {
  type      = "Microsoft.MachineLearningServices/workspaces/models@${local.ml_rest_api_version}"
  name      = local.ml_model_name
  parent_id = module.ml_workspace.id
  tags      = merge(local.extra_tags, {})
  body = jsonencode({
    properties = {
      description = "code"
      isArchived  = false
    }
  })
  response_export_values = ["*"]
}

# Create model version

resource "azapi_resource" "ml_model_version" {
  type      = "Microsoft.MachineLearningServices/workspaces/models/versions@${local.ml_rest_api_version}"
  name      = "1"
  parent_id = jsondecode(azapi_resource.ml_model.output).id
  tags      = merge(local.extra_tags, {})
  body = jsonencode({
    properties = {
      modelUri = format("azureml://subscriptions/%s/resourceGroups/%s/workspaces/%s/dataStores/%s/paths/%s",
        data.azurerm_client_config.main.subscription_id,
        module.rg.resource_group_name,
        module.ml_workspace.name,
        module.ml_workspace.datastore_blob_storage[local.model_datastore_name].name,
        "models"
      )
      modelType   = "triton_model"
      description = "${local.ml_model_name}-1"
      properties  = {}
    }
  })
  response_export_values = ["*"]

  depends_on = [terraform_data.copy_model]
}

# Create online endpoint
resource "azapi_resource" "ml_online_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/onlineEndpoints@${local.ml_rest_api_version}"
  name      = local.ml_online_endpoint_name
  location  = module.azure_region.location_cli
  parent_id = module.ml_workspace.id
  tags      = merge(local.extra_tags, {})
  identity {
    type = "SystemAssigned"
  }
  body = jsonencode({
    properties = {
      authMode            = "Key"
      publicNetworkAccess = "Enabled"
      description         = local.ml_online_endpoint_name
    }
  })
  response_export_values = ["*"]
}

resource "azapi_resource" "ml_online_endpoint_deployment" {
  type      = "Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments@${local.ml_rest_api_version}"
  name      = local.ml_online_endpoint_deployment_name
  location  = module.azure_region.location_cli
  parent_id = jsondecode(azapi_resource.ml_online_endpoint.output).id
  tags      = merge(local.extra_tags, {})
  body = jsonencode({
    properties = {
      appInsightsEnabled        = false
      endpointComputeType       = "Managed"
      description               = local.ml_online_endpoint_deployment_name
      egressPublicNetworkAccess = "Enabled"
      model                     = jsondecode(azapi_resource.ml_model_version.output).id
      instanceType              = var.ml_vm_size
      livenessProbe = {
        failureThreshold = 30
        initialDelay     = "PT10S"
        period           = "PT10S"
        successThreshold = 1
        timeout          = "PT2S"
      }
      readinessProbe = {
        failureThreshold = 30
        initialDelay     = "PT10S"
        period           = "PT10S"
        successThreshold = 1
        timeout          = "PT2S"
      }
      requestSettings = {
        maxConcurrentRequestsPerInstance = 1
        maxQueueWait                     = "PT0S"
        requestTimeout                   = "PT5S"
      }
      scaleSettings = {
        scaleType = "Default"
      }
    }
    sku = {
      capacity = 1
      name     = "Default"
      tier     = "Standard"
    }
  })
  response_export_values = ["*"]
  lifecycle {
    replace_triggered_by = [
      terraform_data.replace_ml_rest_api_object.output.instanceType
    ]
  }
}

resource "azapi_resource_action" "ml_online_endpoint_deployment_traffic_100" {
  type        = "Microsoft.MachineLearningServices/workspaces/onlineEndpoints@${local.ml_rest_api_version}"
  resource_id = azapi_resource.ml_online_endpoint.id
  method      = "PUT"

  body = jsonencode({
    location = module.azure_region.location_cli
    properties = {
      authMode = jsondecode(azapi_resource.ml_online_endpoint.output).properties.authMode
      traffic = {
        (azapi_resource.ml_online_endpoint_deployment.name) = 100
      }
    }
  })
  response_export_values = ["*"]

  lifecycle {
    replace_triggered_by = [
      azapi_resource.ml_online_endpoint_deployment.id
    ]
  }

  depends_on = [azapi_resource.ml_online_endpoint_deployment]

}

resource "azapi_resource_action" "ml_online_endpoint_deployment_traffic_0" {
  type        = "Microsoft.MachineLearningServices/workspaces/onlineEndpoints@${local.ml_rest_api_version}"
  resource_id = azapi_resource.ml_online_endpoint.id
  method      = "PUT"

  body = jsonencode({
    location = module.azure_region.location_cli
    properties = {
      authMode = jsondecode(azapi_resource.ml_online_endpoint.output).properties.authMode
      traffic  = {}
    }
  })
  response_export_values = ["*"]

  lifecycle {
    replace_triggered_by = [
      azapi_resource.ml_online_endpoint_deployment.id
    ]
  }
  when = "destroy"

  depends_on = [azapi_resource.ml_online_endpoint_deployment]

}