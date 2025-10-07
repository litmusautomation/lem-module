output "private_ip" {
  value = module.edgemanager_vm.private_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/${var.key_name}.pem ${var.admin_user_name}@${module.edgemanager_vm.private_ip}"
}
