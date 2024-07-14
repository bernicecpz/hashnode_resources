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

  body = jsonencode({
    openapi = "3.0.1"
    info = {
        title = "${var.webname}-${var.environment}"
        description = "${var.apigw_description}"
    }

    paths = {
        "/{fe-target}" = {
            get = {
                x-amazon-apigateway-integration = {
                    httpMethod = "GET"
                    type = "AWS"
                    credentials = aws_iam_role.ApiGatewayToS3Role.arn
                    uri = "arn:aws:apigateway:${var.region}:s3:path/${var.webname}-${var.environment}-${var.account_id}/{fe-target}/index.html"
                    requestParameters = {
                      "integration.request.path.fe-target" = "method.request.path.fe-target"
                    }

                    responses = {
                      "4\\d{2}" = {
                        statusCode = "400"
                        responseTemplates = {
                          "text/plain" = "#set($inputRoot = $input.path('$'))\n400 Error: Bad Request"
                        }
                      }

                      "404" = {
                        statusCode = "404"
                        responseTemplates = {
                          "text/plain" = "#set($inputRoot = $input.path('$'))\n404 Error: Page not found"
                        }
                      }

                      "5\\d{2}" = {
                        statusCode = "500"
                        responseTemplates = {
                          "text/plain" = "#set($inputRoot = $input.path('$'))\r\n500 Error: Internal Server Error"
                        }
                      }


                      "2\\d{2}" = {
                        statusCode = "200"
                        responseParameters = {
                          "method.response.header.Cache-Control" = "'private, max-age=900'",
                          "method.response.header.X-Frame-Options" = "'deny'",
                          "method.response.header.Strict-Transport-Security" = "'max-age=31536000 ; includeSubDomains'",
                          "method.response.header.Content-Type" = "integration.response.header.Content-Type",
                          "method.response.header.Content-Length" = "integration.response.header.Content-Length",
                          "method.response.header.Timestamp" = "integration.response.header.Date"
                        }
                      }
                    }
                }
                parameters = [
                    {
                      name = "fe-target"
                      in = "path"
                      required = true
                      schema = {
                        type = "string"
                      }
                    }
                ]
                responses = {
                  "200" = {
                    headers = {
                      "X-Frame-Options" = {
                        schema = {
                          type = "string"
                        }
                      }
                      "Strict-Transport-Security" = {
                        schema = {
                          type = "string"
                        }
                      }
                      "Cache-Control" = {
                        schema = {
                          type = "string"
                        }
                      }
                      "Content-Length" = {
                        schema = {
                          type = "string"
                        }
                      }
                      "Content-Type" = {
                        schema = {
                          type = "string"
                        }
                      }
                      "Timestamp" : {
                        schema = {
                          type = "string"
                        } 
                      }
                    }
                    content = {}
                  }
                  "404" = {
                    description = "404 response"
                    content = {}
                  }
                  "400" = {
                    description = "400 response"
                    content = {}
                  }
                  "500" = {
                    description = "500 response"
                    content = {}
                  }
                }
            }
        }
      
      "/{fe-target}/static/{subfolder+}" = {
        get = {
          x-amazon-apigateway-integration = {
              httpMethod = "GET"
              type = "AWS"
              credentials = aws_iam_role.ApiGatewayToS3Role.arn
              uri = "arn:aws:apigateway:${var.region}:s3:path/${var.webname}-${var.environment}-${var.account_id}/{fe-target}/static/{subfolder}"
              requestParameters = {
                "integration.request.path.fe-target" = "method.request.path.fe-target"
                "integration.request.path.subfolder" = "method.request.path.subfolder"
              }

              responses = {
                "4\\d{2}" = {
                  statusCode = "400"
                  responseTemplates = {
                    "text/plain" = "#set($inputRoot = $input.path('$'))\n400 Error: Bad Request"
                  }
                }

                "404" = {
                  statusCode = "404"
                  responseTemplates = {
                    "text/plain" = "#set($inputRoot = $input.path('$'))\n404 Error: Page not found"
                  }
                }

                "5\\d{2}" = {
                  statusCode = "500"
                  responseTemplates = {
                    "text/plain" = "#set($inputRoot = $input.path('$'))\r\n500 Error: Internal Server Error"
                  }
                }


                "2\\d{2}" = {
                  statusCode = "200"
                  responseParameters = {
                    "method.response.header.Cache-Control" = "'private, max-age=900'",
                    "method.response.header.X-Frame-Options" = "'deny'",
                    "method.response.header.Strict-Transport-Security" = "'max-age=31536000 ; includeSubDomains'",
                    "method.response.header.Content-Type" = "integration.response.header.Content-Type",
                    "method.response.header.Content-Length" = "integration.response.header.Content-Length",
                    "method.response.header.Timestamp" = "integration.response.header.Date"
                  }
                }
              }
          }

          parameters = [
            {
              name = "fe-target"
              in = "path"
              required = true
              schema = {
                type = "string"
              }
            },
            {
              name = "subfolder"
              in = "path"
              required = true
              schema = {
                type = "string"
              }
            }
          ]

          responses = {
            "200" = {
              headers = {
                "X-Frame-Options" = {
                  schema = {
                    type = "string"
                  }
                }
                "Strict-Transport-Security" = {
                  schema = {
                    type = "string"
                  }
                }
                "Cache-Control" = {
                  schema = {
                    type = "string"
                  }
                }
                "Content-Length" = {
                  schema = {
                    type = "string"
                  }
                }
                "Content-Type" = {
                  schema = {
                    type = "string"
                  }
                }
                "Timestamp" : {
                  schema = {
                    type = "string"
                  } 
                }
              }
              content = {}
            }
            "404" = {
              description = "404 response"
              content = {}
            }
            "400" = {
              description = "400 response"
              content = {}
            }
            "500" = {
              description = "500 response"
              content = {}
            }
          }
        }
      }
    }

    x-amazon-apigateway-binary-media-types = [ "image/*", "font/ttf", "binary/octet-stream" ]
  })

}



# Deployment
resource "aws_api_gateway_deployment" "S3APIDeployment" {

  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  description = "${var.deployment_description}"
}


# Stage
resource "aws_api_gateway_stage" "frontend" {
  deployment_id = aws_api_gateway_deployment.S3APIDeployment.id
  rest_api_id = aws_api_gateway_rest_api.GenericRestApiGateway.id
  stage_name = "frontend"
}
