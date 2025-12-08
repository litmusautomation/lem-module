provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  features {}
}

module "edgemanager-example" {
  source                    = "git@github.com:litmusautomation/lem-module//azure?ref=main"
  name                      = var.name
  oem_name                  = var.oem_name
  app_version               = var.app_version
  location                  = var.location
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  subnet_id                 = var.subnet_id
  image_resource_group_name = var.image_resource_group_name
  ssh_pub_key               = var.ssh_pub_key
  subscription_id           = var.subscription_id
}
