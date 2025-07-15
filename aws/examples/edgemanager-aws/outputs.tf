output "edgemanager_url" {
  value = module.edgemanager-example.APP_HTTPS_URL
}

output "edgemanager_admin_url" {
  value = module.edgemanager-example.ADMIN_APP_HTTPS_URL
}

output "APP_VERSION" {
  value = var.app_version
}

