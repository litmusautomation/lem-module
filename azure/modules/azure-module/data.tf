locals {
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Product     = "Litmus Edge Manager"
    Application = var.image_version
  }
}

data "azurerm_location" "default" {
  location = var.location
}

data "azurerm_image" "edgemanager_image" {
  name_regex          = "${var.image_version}-*"
  resource_group_name = var.image_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_id
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}
