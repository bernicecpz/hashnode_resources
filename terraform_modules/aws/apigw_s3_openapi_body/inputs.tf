variable "webname" {
  type = string
  default = "sp"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "account_id" {
    type = string
    default = null
}

variable "apigw_iam_rolename" {
  type = string
  default = "apigateway-to-s3-role"
}

variable "apigw_iam_policies" {
  type = list
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

variable "apigw_description" {
  type = string
  default = "Create a API Gateway RestApi for serving Single Page Application"
}


variable "deployment_description" {
  type = string
  default = "Deployment v1.0"
}

variable "region" {
  type = string
  default = "ap-southeast-1"
}