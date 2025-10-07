module "edgemanager-azure" {
  source                    = "./modules/azure-module"
  location                  = var.location
  name                      = var.name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  subnet_id                 = var.subnet_id
  admin_user_name           = var.admin_user_name
  image_version             = "${var.oem_name}-${var.app_version}"
  image_resource_group_name = var.image_resource_group_name
  custom_ssh_pub_key        = var.ssh_pub_key
  custom_data               = data.cloudinit_config.config.rendered

  # optional parameters
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_cidr_ssh_blocks = var.ingress_cidr_ssh_blocks
}
