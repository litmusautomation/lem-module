output "APP_VERSION" {
  value = var.app_version
}

output "ADMIN_APP_HTTPS_URL" {
  value = "https://${module.edgemanager-aws.private_ip}:8446"
}

output "APP_HTTPS_URL" {
  value = "https://${module.edgemanager-aws.private_ip}"
}

output "PRIVATE_IP" {
  value = module.edgemanager-aws.private_ip
}
