variable "execution_role" { type = string }

variable "name" {
  type    = string
  default = "bria"
}

variable "model_data_url" {
  type    = string
  default = "s3://sagemaker-us-east-1-t1nodxokaqeoaqyy7i4is78j1tqqause1b-s3alias/clip/"
}

variable "model_name" {
  type    = string
  default = "clip"
}

variable "sagemaker_image" {
  type    = string
  default = "542375318953.dkr.ecr.us-east-1.amazonaws.com/sagemaker-tritonserver:latest"
}

variable "sagemaker_instance_type" {
  type    = string
  default = "ml.g4dn.xlarge"
}

variable "sagemaker_initial_instance_count" {
  type    = number
  default = 1
}

variable "sagemaker_initial_variant_weight" {
  type    = number
  default = 1.0
}
