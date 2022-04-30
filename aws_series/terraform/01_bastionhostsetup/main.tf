module "infra_module" {
  source                       = "./infra_module"
  vpc_name                     = "demo-infra"
  cidr_block                   = var.cidr_block
  secondary_cidr_block_public  = var.secondary_cidr_block_public
  secondary_cidr_block_private = var.secondary_cidr_block_private
  set_availability_zone        = var.set_availability_zone
}