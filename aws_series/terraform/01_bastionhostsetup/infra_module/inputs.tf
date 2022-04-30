# The variables act as arguments to provide inputs
variable "vpc_name" {
    type = string
    description = "VPC name"
    default = "tinker-vpc"
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block used for VPC"
}

variable "secondary_cidr_block_public" {
    type = string
    description = "The secondary CIDR block for the public subnet"
}

variable "secondary_cidr_block_private" {
    type = string
    description = "The secondary CIDR block for the private subnet"
}

variable "set_availability_zone" {
    type = string
    description = "Provide default availability zone for resources"
    default = "ap-southeast-1a"
}