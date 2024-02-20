output "sagemaker_endpoint_name" {
  description = "Name of the SageMaker Endpoint"
  value       = aws_sagemaker_endpoint.endpoint.name
}

output "model_file_name" {
  description = "Name of the Model File"
  value       = "clip_image_model_v0.tar.gz"
}
