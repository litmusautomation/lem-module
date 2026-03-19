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

        users:
          - name: ${var.admin_user_name}
            ssh_authorized_keys:
              - ${var.ssh_pub_key}
        EOT
    }]
  }
}

data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  dynamic "part" {
    for_each = var.ssh_enabled ? concat(local.cloudinit.default, local.cloudinit.set_ssh_key) : local.cloudinit.default
    content {
      content    = part.value.content
      merge_type = "list(append)+dict(recurse_array)+str()"
    }
  }
}
