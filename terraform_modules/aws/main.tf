data "aws_caller_identity" "current" {}

module "ApiGwS3Frontend" {
  source = "./apigw_s3_openapi_body"
  webname = "sp"
  environment = "dev"
  account_id = data.aws_caller_identity.current.account_id
  region = "ap-southeast-1"
  apigw_description = "[Terraform]Create a API Gateway RestApi for serving Single Page Application through OpenAPI specification`body` argument"
  deployment_description = "Deployment v1.0"
}


module "ApiGwS3Frontend" {
  source = "./apigw_s3_tf_resources"
  webname = "sp"
  environment = "dev"
  account_id = data.aws_caller_identity.current.account_id
  region = "ap-southeast-1"
  apigw_description = "[Terraform]Create a API Gateway RestApi for serving Single Page Application via Terraform resources"
  deployment_description = "Deployment v1.0"
}