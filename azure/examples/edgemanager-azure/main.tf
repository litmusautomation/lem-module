provider "azurerm" {
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
  features {}
}

module "edgemanager-example" {
  source                    = "github.com/litmusautomation/lem-module//azure?ref=LIT-5811-code-improvements"
  name                      = var.name
  oem_name                  = var.oem_name
  app_version               = var.app_version
  location                  = var.location
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  subnet_name               = var.subnet_name
  image_resource_group_name = var.image_resource_group_name
  ssh_enabled               = var.ssh_enabled
  ssh_pub_key               = var.ssh_pub_key
  subscription_id           = var.subscription_id
}
