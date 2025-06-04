resource "azurerm_virtual_machine" "edgemanager_vm" {
  name                  = "${var.name}-vm"
  location              = data.azurerm_location.default.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.edgemanager_nic.id]
  vm_size               = var.vm_size

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "${var.name}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    id = data.azurerm_image.edgemanager_image.id
  }

  os_profile {
    computer_name  = "${var.name}-server"
    admin_username = var.admin_user_name
    custom_data    = var.custom_data
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_user_name}/.ssh/authorized_keys"
      key_data = var.custom_ssh_pub_key
    }
  }

  tags = merge(local.tags, var.tags)
}
