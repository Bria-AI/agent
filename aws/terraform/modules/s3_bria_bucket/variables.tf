variable "name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "versioning_enabled" {
  type        = string
  description = "Whether to enable versioning on the bucket or not."
  default     = false
}
