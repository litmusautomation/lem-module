locals {
  cloudinit = {
    default = [{
      content = <<-EOT
        #cloud-config
        # See documentation for more configuration examples
        # https://cloudinit.readthedocs.io/en/latest/reference/examples.html 
        EOT
    }]
    set_ssh_key = (var.ssh_pub_key != "") ? [{ content = templatefile("${path.cwd}/cloudinit/add-ssh-key.tmpl", { custom_ssh_pub_key = var.ssh_pub_key }) }] : []
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
