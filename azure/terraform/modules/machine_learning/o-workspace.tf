output "id" {
  value       = azurerm_machine_learning_workspace.workspace.id
  description = " The ID of the Machine Learning Workspace."
}

output "discovery_url" {
  value       = azurerm_machine_learning_workspace.workspace.discovery_url
  description = " The url for the discovery service to identify regional endpoints for machine learning experimentation services."
}

output "workspace_id" {
  value       = azurerm_machine_learning_workspace.workspace.workspace_id
  description = "The immutable id associated with this workspace."
}

output "identity" {
  value       = azurerm_machine_learning_workspace.workspace.identity.0
  description = "The identity of the workspace"
}