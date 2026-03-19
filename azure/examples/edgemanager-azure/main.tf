provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  features {}
}

module "edgemanager-example" {
  source                    = "github.com/litmusautomation/lem-module//azure?ref=main"
  name                      = var.name
  oem_name                  = var.oem_name
  app_version               = var.app_version
  location                  = var.location
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  subnet_name               = var.subnet_name
  image_resource_group_name = var.image_resource_group_name
  ssh_pub_key               = var.ssh_pub_key
  subscription_id           = var.subscription_id

  # optional
  admin_user_name         = var.admin_user_name
  ssh_enabled             = var.ssh_enabled
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_cidr_ssh_blocks = var.ingress_cidr_ssh_blocks
  ingress_tcp_ports       = var.ingress_tcp_ports
  ingress_udp_ports       = var.ingress_udp_ports
}
