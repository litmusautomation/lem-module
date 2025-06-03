locals {
  cloudinit = {
    default = [{
      content = <<-EOT
        #cloud-config
        # See documentation for more configuration examples
        # https://cloudinit.readthedocs.io/en/latest/reference/examples.html 
        EOT
    }]
    set_ssh_key = [{
      content = <<-EOT
        #cloud-config

        runcmd:
          - echo ${var.ssh_pub_key} >> /home/${var.admin_user_name}/.ssh/authorized_keys
        EOT
    }]
  }
}

data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  dynamic "part" {
    for_each = concat(local.cloudinit.default, local.cloudinit.set_ssh_key)
    content {
      content    = part.value.content
      merge_type = "list(append)+dict(recurse_array)+str()"
    }
  }
}
