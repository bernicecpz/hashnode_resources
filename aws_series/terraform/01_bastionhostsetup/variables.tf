variable "cidr_block" {
  type        = string
  description = "The CIDR block used for TF created VPC"
  default     = "10.1.0.0/16"
}

variable "secondary_cidr_block_public" {
  type        = string
  description = "The secondary CIDR block for the public subnet"
  default     = "10.1.0.0/24"
}

variable "secondary_cidr_block_private" {
  type        = string
  description = "The secondary CIDR block for the private subnet"
  default     = "10.1.1.0/24"
}

variable "set_availability_zone" {
  type        = string
  description = "Provide default availability zone for resources"
  default     = "ap-southeast-1a"
}