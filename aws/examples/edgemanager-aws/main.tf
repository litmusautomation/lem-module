provider "aws" {
  region = "us-east-1"
}

module "edgemanager-example" {
  source      = "git@github.com:litmusautomation/lem-module//aws?ref=main"
  name        = var.name
  oem_name    = var.oem_name    # name of the edge manager
  app_version = var.app_version # version of the application
  vpc_id      = var.vpc_id      # vpc id
  subnet_id   = var.subnet_id   # subnet id
  key_name    = var.key_name    # key pair name
  ami_owner   = var.ami_owner   # aws account id
  ssh_pub_key = var.ssh_pub_key # optional custom ssh public key
}
