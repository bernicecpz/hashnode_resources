
# Terraform settings
terraform {
  required_version = ">= 1.9.2"

  required_providers {
    aws = {
      version = "~> 5.0"
      source = "hashicorp/aws"
    }
  }

}

provider "aws" {
  region  = "ap-southeast-1"
}