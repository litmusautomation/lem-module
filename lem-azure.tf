
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.3.0"
    }
  }

  required_version = ">= 1.1.0"
}
provider "azurerm" {
  resource_provider_registrations = "none"
  features {
    resource_group {
        prevent_deletion_if_contains_resources = false
    }
  }
}

# Variables
variable "project_name" {
  description = "Specifies a name for generating resource names."
  default     = "lem"
}

variable "resource_group" {
  description = "Specifies a name for resource group."
  default     = "lem"
}
variable "location" {
  description = "Specifies the location for all resources."
  default     = "East US"
}

variable "vm_size" {
  description = "Size of the VM"
  default     = "Standard_B4ms"
}

variable "public_ip_allocation_method" {
  description = "Public IP address allocation method"
  default     = "Dynamic"
}

variable "virtual_network_address_prefix" {
  description = "Virtual network address."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "Subnet CIDR."
  default     = "10.0.0.0/24"
}

variable "ssh_public_key" {
  description = "SSH Public Key for Virtual Machine"
  type        = string
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}"
  location = var.location
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "http_rule"
    priority                   = 124
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https_rule"
    priority                   = 125
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "lem_admin_rule"
    priority                   = 126
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8446"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "remote_rule"
    priority                   = 127
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "51820"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "mqtt_ssl_rule"
    priority                   = 128
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8883"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ntp_rule"
    priority                   = 129
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "123"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.project_name}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.public_ip_allocation_method
  sku                 = "Basic"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.project_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
}

# Association of NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.project_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.project_name}-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 160
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "litmusautomation1582760223280"
    offer     = "litmusedgemanager"
    sku       = "lem-azure"
    version   = "latest"
  }

  plan {
    name = "lem-azure"
    publisher = "litmusautomation1582760223280"
    product = "litmusedgemanager"
  }


  identity {
    type = "SystemAssigned"
  }
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}
