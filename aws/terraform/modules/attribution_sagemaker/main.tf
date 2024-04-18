resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
  name = "${var.name}-attribution-agent-config"

  production_variants {
    variant_name           = aws_sagemaker_model.model.name
    model_name             = aws_sagemaker_model.model.name
    initial_instance_count = var.sagemaker_initial_instance_count
    instance_type          = var.sagemaker_instance_type
    initial_variant_weight = var.sagemaker_initial_variant_weight
  }
}

resource "aws_sagemaker_model" "model" {
  name               = var.model_name
  execution_role_arn = var.execution_role

  primary_container {
    image          = var.sagemaker_image
    mode           = "MultiModel"
    model_data_url = var.model_data_url
  }
}

resource "aws_sagemaker_endpoint" "endpoint" {
  name                 = "${var.name}-attribution-agent"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name
}
