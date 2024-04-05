output "compute_cluster" {
  value = {
    for k, v in azurerm_machine_learning_compute_cluster.compute_cluster : v.name => v
  }
  description = <<EOF
In addition to the variable - the following Attributes are exported:

    id - The ID of the Machine Learning Compute Cluster.

    identity - An identity block as defined below, which contains the Managed Service Identity information for this Machine Learning Compute Cluster.

A identity block exports the following:

    principal_id - The Principal ID for the Service Principal associated with the Managed Service Identity of this Machine Learning Compute Cluster.

    tenant_id - The Tenant ID for the Service Principal associated with the Managed Service Identity of this Machine Learning Compute Cluster.

EOF
}