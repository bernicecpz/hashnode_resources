resource "aws_s3_bucket" "FrontendBucket" {
  bucket = "${var.webname}-${var.environment}-${var.account_id}"
  force_destroy = true

  tags = {
    "app-name" = "${var.webname}"
    "env" = "${var.environment}"
  } 
}

data "aws_iam_policy_document" "ensure_https_policy_document" {
  statement {
    effect = "Deny"

    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    actions = [ "s3:GetObject" ]
    resources = [ join("", [aws_s3_bucket.FrontendBucket.arn, "/*"]) ]
    
    
    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = [ false ]
    }
  }
}

resource "aws_s3_bucket_policy" "ensure_https_bucket_policy" {
  bucket =  aws_s3_bucket.FrontendBucket.id
  policy = data.aws_iam_policy_document.ensure_https_policy_document.json
}

resource "aws_iam_role" "ApiGatewayToS3Role" {
  name = "${var.apigw_iam_rolename}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "apigateway.amazonaws.com"
        }
    }]
  })

  managed_policy_arns = "${var.apigw_iam_policies}"

  tags = {
    "app-name" = "${var.webname}"
    "env" = "${var.environment}"
  }
}