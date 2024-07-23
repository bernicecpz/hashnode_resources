## Method responses for path /{fe-target}
resource "aws_api_gateway_method_response" "Status200Response" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = "200"

  # The mapping here MUST match integration response
  response_parameters = {
    "method.response.header.Timestamp" = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type" = true
    "method.response.header.X-Frame-Options" = true
    "method.response.header.Strict-Transport-Security" = true
    "method.response.header.Cache-Control" = true
  }
}

resource "aws_api_gateway_method_response" "Status400Response" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = "400"
}

resource "aws_api_gateway_method_response" "Status404Response" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = "404"
}

resource "aws_api_gateway_method_response" "Status500Response" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = "500"
}


## Integration responses for path /{fe-target}

resource "aws_api_gateway_integration_response" "IntegrationResponse200" {
  depends_on = [ 
    aws_api_gateway_integration.S3IntegrationRoot
  ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = aws_api_gateway_method_response.Status200Response.status_code

  response_parameters = {
    "method.response.header.Timestamp" = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type" = "integration.response.header.Content-Type"
    "method.response.header.Cache-Control" = "'private, max-age=900'"
    "method.response.header.X-Frame-Options" = "'deny'"
    "method.response.header.Strict-Transport-Security" = "'max-age=31536000; includeSubDomains'"
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse400" {
  depends_on = [ aws_api_gateway_integration.S3IntegrationRoot ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = aws_api_gateway_method_response.Status400Response.status_code
  
  response_templates = {
    "text/plain" = <<EOF
      #set($inputRoot = $input.path('$'))\n404 Error: Bad Request
    EOF
  }

  selection_pattern = "4\\d{2}"

}

resource "aws_api_gateway_integration_response" "IntegrationResponse404" {
  depends_on = [ aws_api_gateway_integration.S3IntegrationRoot ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = aws_api_gateway_method_response.Status404Response.status_code
  

  response_templates = {
    "text/plain" = <<EOF
      #set($inputRoot = $input.path('$'))\n404 Error: Page not found
    EOF
  }

  selection_pattern = "404"

}

resource "aws_api_gateway_integration_response" "IntegrationResponse500" {
  depends_on = [ aws_api_gateway_integration.S3IntegrationRoot ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTarget.id
  http_method = aws_api_gateway_method.AccessFrontendBucket.http_method
  status_code = aws_api_gateway_method_response.Status500Response.status_code
  

  response_templates = {
    "text/plain" = <<EOF
      #set($inputRoot = $input.path('$'))\r\n500 Error: Internal Server Error
    EOF
  }

  selection_pattern = "500"

}


## Method response for path /{fe-target}/static/{subfolder}


resource "aws_api_gateway_method_response" "Status200ResponseSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = "200"

  # The mapping here MUST match integration response
  response_parameters = {
    "method.response.header.Timestamp" = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type" = true
    "method.response.header.X-Frame-Options" = true
    "method.response.header.Strict-Transport-Security" = true
    "method.response.header.Cache-Control" = true
  }
}

resource "aws_api_gateway_method_response" "Status400ResponseSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = "400"
}

resource "aws_api_gateway_method_response" "Status404ResponseSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = "404"
}

resource "aws_api_gateway_method_response" "Status500ResponseSubFolder" {
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = "500"
}


## Integration responses for path /{fe-target}/static/{subfolder}

resource "aws_api_gateway_integration_response" "IntegrationResponse200SubFolder" {
  depends_on = [ 
    aws_api_gateway_integration.S3IntegrationSubFolder
  ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = aws_api_gateway_method_response.Status200ResponseSubFolder.status_code

  response_parameters = {
    "method.response.header.Timestamp" = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type" = "integration.response.header.Content-Type"
    "method.response.header.Cache-Control" = "'private, max-age=900'"
    "method.response.header.X-Frame-Options" = "'deny'"
    "method.response.header.Strict-Transport-Security" = "'max-age=31536000; includeSubDomains'"
  }
}


resource "aws_api_gateway_integration_response" "IntegrationResponse400SubFolder" {
  depends_on = [ aws_api_gateway_integration.S3IntegrationSubFolder ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = aws_api_gateway_method_response.Status400ResponseSubFolder.status_code
  
  response_templates = {
    "text/plain" = <<EOF
      #set($inputRoot = $input.path('$'))\n404 Error: Bad Request
    EOF
  }

  selection_pattern = "4\\d{2}"

}

resource "aws_api_gateway_integration_response" "IntegrationResponse404SubFolder" {
  depends_on = [ aws_api_gateway_integration.S3IntegrationSubFolder ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = aws_api_gateway_method_response.Status404ResponseSubFolder.status_code
  

  response_templates = {
    "text/plain" = <<EOF
      #set($inputRoot = $input.path('$'))\n404 Error: Page not found
    EOF
  }

  selection_pattern = "404"

}

resource "aws_api_gateway_integration_response" "IntegrationResponse500SubFolder" {
  depends_on = [ aws_api_gateway_integration.S3IntegrationSubFolder ]

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  resource_id = aws_api_gateway_resource.FeTargetStaticSubFolder.id
  http_method = aws_api_gateway_method.AccessFrontendBucketSubFolder.http_method
  status_code = aws_api_gateway_method_response.Status500ResponseSubFolder.status_code
  

  response_templates = {
    "text/plain" = <<EOF
      #set($inputRoot = $input.path('$'))\r\n500 Error: Internal Server Error
    EOF
  }

  selection_pattern = "500"

}

