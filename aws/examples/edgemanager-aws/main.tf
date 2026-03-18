provider "aws" {
  region = var.region
}

module "edgemanager-example" {
  source      = "github.com/litmusautomation/lem-module//aws?ref=main"
  name        = var.name
  oem_name    = var.oem_name
  app_version = var.app_version
  vpc_id      = var.vpc_id
  subnet_id   = var.subnet_id
  key_name    = var.key_name
  ami_owner   = var.ami_owner
  ssh_pub_key = var.ssh_pub_key
}
