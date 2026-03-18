provider "aws" {
  region = var.region
}

module "edgemanager-example" {
  source      = "github.com/litmusautomation/lem-module//aws?ref=LIT-5811-code-improvements"
  name        = var.name
  oem_name    = var.oem_name
  app_version = var.app_version
  region      = var.region
  vpc_id      = var.vpc_id
  subnet_id   = var.subnet_id
  ami_owner   = var.ami_owner
  key_name    = var.key_name
}
