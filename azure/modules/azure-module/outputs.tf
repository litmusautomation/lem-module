output "private_ip" {
  value = azurerm_network_interface.edgemanager_nic.private_ip_address
}

output "ssh_command" {
  value = "ssh -i <custom_ssh_pub_key> ${var.admin_user_name}@${azurerm_network_interface.edgemanager_nic.private_ip_address}"
}
