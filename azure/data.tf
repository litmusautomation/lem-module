locals {
  cloudinit = {
    default = [{
      content = <<-EOT
        #cloud-config
        # See documentation for more configuration examples
        # https://cloudinit.readthedocs.io/en/latest/reference/examples.html 
        EOT
    }]
  }
}

data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  dynamic "part" {
    for_each = local.cloudinit.default
    content {
      content    = part.value.content
      merge_type = "list(append)+dict(recurse_array)+str()"
    }
  }
}
