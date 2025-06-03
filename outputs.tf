output "EC2_PRIVATE_IP" {
  value = module.edgemanager-aws.private_ip
}

output "EC2_HTTPS_URL" {
  value = "https://${module.edgemanager-aws.private_ip}"
}

output "EC2_SSH" {
  value = module.edgemanager-aws.ssh_command
}

output "APP_VERSION" {
  value = var.app_version
}
