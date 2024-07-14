
resource "aws_api_gateway_rest_api" "GenericRestApiGateway" {
  name = "${var.webname}-web-${var.environment}"
  
  description = "${var.apigw_description}"
  
  endpoint_configuration {
    types = ["REGIONAL"]  
  }

  binary_media_types = [ 
    "font~1ttf",
    "binary~1octet-stream",
    "image~1"
   ]
}


# Defining the resources for the respective paths

# Path /{fe-target}
resource "aws_api_gateway_resource" "FeTarget" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  parent_id = aws_api_gateway_rest_api.GenericRestApiGateway.root_resource_id
  path_part = "{fe-target}"
}

## Path /{fe-target}/static
resource "aws_api_gateway_resource" "FeTargetStatic" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  parent_id = aws_api_gateway_resource.FeTarget.id
  path_part = "static"
}

## Path /{fe-target}/static/{subfolder+}
resource "aws_api_gateway_resource" "FeTargetStaticSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  parent_id = aws_api_gateway_resource.FeTargetStatic.id
  path_part = "{subfolder+}"
}

# Defines the role used by APIGW to access to target S3 bucket used to host the Frontend
resource "aws_api_gateway_method" "AccessFrontendBucket" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = "GET"
  authorization = "AWS_IAM"

  # This must be defined for the target integration request to map to it
  request_parameters = {
    "method.request.path.fe-target" = true
  }

}

# For Path /{fe-target}
resource "aws_api_gateway_integration" "S3IntegrationRoot" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method

  integration_http_method = "GET"
  type = "AWS"

  uri = "arn:aws:apigateway:${var.region}:s3:path/${var.webname}-${var.environment}-${var.account_id}/{fe-target}/index.html"
  credentials = aws_iam_role.ApiGatewayToS3Role.arn

  request_parameters = {
    "integration.request.path.fe-target" = "method.request.path.fe-target"
  }

}

# For Path /{fe-target}/static/{subfolder+}
resource "aws_api_gateway_method" "AccessFrontendBucketSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = "GET"
  authorization = "AWS_IAM"

  # This must be defined for the target integration request to map to it
  request_parameters = {
    "method.request.path.fe-target" = true
    "method.request.path.subfolder" = true
  }

  
}

resource "aws_api_gateway_integration" "S3IntegrationSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  
  integration_http_method = "GET"
  type = "AWS"

  uri = "arn:aws:apigateway:${var.region}:s3:path/${var.webname}-${var.environment}-${var.account_id}/{fe-target}/static/{subfolder}"
  credentials = aws_iam_role.ApiGatewayToS3Role.arn

  request_parameters = {
    "integration.request.path.fe-target" = "method.request.path.fe-target"
    "integration.request.path.subfolder" = "method.request.path.subfolder"
  }  

}



# Deployment
resource "aws_api_gateway_deployment" "S3APIDeployment" {
  depends_on  = [
    aws_api_gateway_integration.S3IntegrationRoot,
    aws_api_gateway_integration.S3IntegrationSubFolder
  ]
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  description = "${var.deployment_description}"
}

resource "aws_api_gateway_stage" "frontend" {
  deployment_id = aws_api_gateway_deployment.S3APIDeployment.id
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  stage_name = "frontend"
}
