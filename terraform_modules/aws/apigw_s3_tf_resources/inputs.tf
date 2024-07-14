variable "iam_role_arn" {
  type = string
  default = null
}

variable "s3_path_override_index" {
  type = string
  default = null
}

variable "environment" {
  type = string
  default = "dev"
}

variable "webname" {
    type = string
    default = "sp"
}

variable "apigw_iam_rolename" {
  type = string
  default = "tf-apigateway-to-s3-role"
}

variable "account_id" {
  type = string
  default = null
}

variable "apigw_iam_policies" {
  type = list
  default = [
    "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

variable "region" {
  type = string
  default = "ap-southeast-1"
}


variable "apigw_description" {
  type = string
  default = "Create a API Gateway RestApi for serving Single Page Application"
}

variable "deployment_description" {
  type = string
  default = "Deployment v1.0"
}