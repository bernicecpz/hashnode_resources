data "aws_caller_identity" "current" {}

module "ApiGwS3Frontend" {
  source = "./apigw_s3"
  webname = "sp"
  environment = "dev"
  account_id = data.aws_caller_identity.current.account_id
  region = "ap-southeast-1"
  apigw_description = "[Terraform]Create a API Gateway RestApi for serving Single Page Application"
  deployment_description = "Deployment v1.0"
}