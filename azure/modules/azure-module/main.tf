resource "azurerm_linux_virtual_machine" "edgemanager_vm" {
  name                  = var.name
  location              = data.azurerm_location.default.location
  resource_group_name   = var.resource_group_name
  size                  = var.vm_size
  admin_username        = var.admin_user_name
  network_interface_ids = [azurerm_network_interface.edgemanager_nic.id]

  admin_ssh_key {
    username   = var.admin_user_name
    public_key = var.custom_ssh_pub_key
  }

  os_disk {
    name                 = "${var.name}-disk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data     = base64encode(var.custom_data)
  source_image_id = data.azurerm_image.edgemanager_image.id

  tags = merge(local.tags, var.tags)
}