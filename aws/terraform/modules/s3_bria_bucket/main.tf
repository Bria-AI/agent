resource "random_string" "id" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-${random_string.id.result}"
}
