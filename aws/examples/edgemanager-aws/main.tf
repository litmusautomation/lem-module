provider "aws" {
  region = var.region
}

module "edgemanager-example" {
  source      = "github.com/litmusautomation/lem-module//aws?ref=main"
  name        = var.name
  oem_name    = var.oem_name
  app_version = var.app_version
  region      = var.region
  vpc_id      = var.vpc_id
  subnet_id   = var.subnet_id
  ami_owner   = var.ami_owner
  key_name    = var.key_name

  # optional
  admin_user_name         = var.admin_user_name
  ssh_enabled             = var.ssh_enabled
  ssh_pub_key             = var.ssh_pub_key
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_cidr_ssh_blocks = var.ingress_cidr_ssh_blocks
  ingress_tcp_ports       = var.ingress_tcp_ports
  ingress_udp_ports       = var.ingress_udp_ports
}
