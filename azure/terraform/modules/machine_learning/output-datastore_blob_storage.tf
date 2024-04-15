output "datastore_blob_storage" {
  value = {
    for k, v in azurerm_machine_learning_datastore_blobstorage.datastore : v.name => v
  }
  description = <<EOF
  id - The ID of the Machine Learning DataStore.
EOF
}