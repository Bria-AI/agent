resource "aws_lambda_function" "api_endpoint" {
  function_name = var.name
  role          = var.execution_role
  package_type  = "Image"
  image_uri     = var.image_uri

  timeout = 30

  environment {
    variables = {
      endpoint  = var.inference_endpoint
      queue_url = var.embeddings_queue_url
    }
  }
}

resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  name        = "Jumpstart_API_Gateway"
  description = "API Gateway for Lambda function"
}

resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_rest_api.root_resource_id
  path_part   = "jumpstart-agent"
}

resource "aws_api_gateway_method" "api_gateway_method" {
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest_api.id
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_endpoint.invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  depends_on = [
    aws_api_gateway_method.api_gateway_method,
    aws_api_gateway_integration.api_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api_gateway_rest_api.id
  description = "Jumpstart API Deployment"
  stage_name  = "unused" # This is a placeholder, real stage is defined in aws_api_gateway_stage

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_gateway_stage" {
  stage_name    = "prod"
  description   = "Production Stage"
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_rest_api.id
  deployment_id = aws_api_gateway_deployment.api_gateway_deployment.id
}

resource "aws_lambda_permission" "lambda_permission_api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_endpoint.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway_rest_api.execution_arn}/prod/jumpstart-agent"
}
