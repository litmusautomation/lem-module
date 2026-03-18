module "edgemanager_vm" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.0"
  name                        = var.name
  ami                         = data.aws_ami.em_ami.id
  instance_type               = var.vm_size
  key_name                    = var.ssh_enabled ? var.key_name : null
  user_data                   = var.user_data
  user_data_replace_on_change = true

  associate_public_ip_address = false
  private_ip                  = var.private_ip

  subnet_id = data.aws_subnet.subnet.id
  vpc_security_group_ids = [
    module.edgemanager_security_group.security_group_id,
  ]
  tags = merge(local.tags, var.tags)
}
