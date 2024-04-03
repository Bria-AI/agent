resource "random_string" "identifier" {
  length      = 4
  min_lower   = 2
  min_numeric = 2

  special = false
  upper   = false
}