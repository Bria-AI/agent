resource "random_string" "identifier" {
  length      = 4
  min_lower   = 2
  min_numeric = 2

  special = false
  upper   = false
}

resource "random_string" "ml_batch_endpoint_identifier" {
  length      = 4
  min_lower   = 2
  min_numeric = 2

  special = false
  upper   = false
}