module "edgemanager-aws" {
  source          = "./modules/aws-module"
  name            = var.name
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  admin_user_name = var.admin_user_name
  key_name        = var.key_name
  image_version   = "${var.oem_name}-${var.app_version}"
  ami_owner       = var.aws_account_id
  user_data       = data.cloudinit_config.config.rendered

  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_cidr_ssh_blocks = var.ingress_cidr_ssh_blocks
}