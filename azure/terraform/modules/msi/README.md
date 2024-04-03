## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description for the role assignment | `string` | `""` | no |
| <a name="input_enable_role_assignment"></a> [enable\_role\_assignment](#input\_enable\_role\_assignment) | Enable role assignment for the MSI | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The region where to create the resources | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the MSI. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of an existing resource group for the MSI. | `string` | n/a | yes |
| <a name="input_role_definition_id"></a> [role\_definition\_id](#input\_role\_definition\_id) | Role definition ID. if empty string you will have to put the role definition name | `string` | `null` | no |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | Role definition name. if empty string you will have to put the role definition ID | `string` | `null` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope to assign the role | `string` | `null` | no |
| <a name="input_skip_service_principal_aad_check"></a> [skip\_service\_principal\_aad\_check](#input\_skip\_service\_principal\_aad\_check) | If the principal\_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag. This argument is only valid if the principal\_id is a Service Principal identity. If it is not a Service Principal identity it will cause the role assignment to fail | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_id"></a> [client\_id](#output\_client\_id) | The Client ID of the MSI |
| <a name="output_id"></a> [id](#output\_id) | The ID of the MSI |
| <a name="output_location"></a> [location](#output\_location) | The location of the MSI |
| <a name="output_name"></a> [name](#output\_name) | The name of the MSI |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The Principal ID of the MSI |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group where the its located |
| <a name="output_role_assignment_definition_id"></a> [role\_assignment\_definition\_id](#output\_role\_assignment\_definition\_id) | n/a |
| <a name="output_role_assignment_id"></a> [role\_assignment\_id](#output\_role\_assignment\_id) | n/a |
| <a name="output_role_assignment_name"></a> [role\_assignment\_name](#output\_role\_assignment\_name) | n/a |
| <a name="output_role_assignment_principal_id"></a> [role\_assignment\_principal\_id](#output\_role\_assignment\_principal\_id) | n/a |
| <a name="output_role_assignment_scope"></a> [role\_assignment\_scope](#output\_role\_assignment\_scope) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags of the MSI |
