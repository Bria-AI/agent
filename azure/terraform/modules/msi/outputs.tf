output "name" {
  value       = azurerm_user_assigned_identity.main.name
  description = "The name of the MSI"
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.main.principal_id
  description = "The Principal ID of the MSI"
}

output "client_id" {
  value       = azurerm_user_assigned_identity.main.client_id
  description = "The Client ID of the MSI"
}

output "id" {
  value       = azurerm_user_assigned_identity.main.id
  description = "The ID of the MSI"
}

output "resource_group_name" {
  value       = azurerm_user_assigned_identity.main.resource_group_name
  description = "The name of the resource group where the its located"
}

output "location" {
  value       = azurerm_user_assigned_identity.main.location
  description = "The location of the MSI"
}

output "tags" {
  value       = azurerm_user_assigned_identity.main.tags
  description = "The tags of the MSI"
}

output "role_assignment_id" {
  value = try(azurerm_role_assignment.role_assignment[0].id, null)
}

output "role_assignment_principal_id" {
  value = try(azurerm_role_assignment.role_assignment[0].principal_id, null)
}

output "role_assignment_scope" {
  value = try(azurerm_role_assignment.role_assignment[0].scope, null)
}
output "role_assignment_name" {
  value = try(azurerm_role_assignment.role_assignment[0].role_definition_name, null)
}

output "role_assignment_definition_id" {
  value = try(azurerm_role_assignment.role_assignment[0].role_definition_id, null)
}