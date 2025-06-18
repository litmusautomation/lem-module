locals {
  tcp_ports = [
    80, 443, 8883,
    9092, 8446, 9093,
    8123, 8543, 9000,
    9004, 9090,
  ]

  udp_ports = [
    51820, 123
  ]

  denied_ports = [
    22
  ]
}

resource "azurerm_network_security_group" "edgemanager_nsg" {
  name                = "${var.name}-nsg"
  location            = data.azurerm_location.default.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = [for port in local.tcp_ports : port]
    content {
      name                       = "allow-tcp-${security_rule.value}"
      priority                   = 100 + index(local.tcp_ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value)
      source_address_prefixes    = var.ingress_cidr_blocks
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = local.udp_ports
    content {
      name                       = "allow-udp-${security_rule.value}"
      priority                   = 200 + index(local.udp_ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value)
      source_address_prefixes    = var.ingress_cidr_blocks
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = local.denied_ports
    content {
      name                   = "deny-tcp-${security_rule.value}"
      priority               = 300 + index(local.denied_ports, security_rule.value)
      direction              = "Inbound"
      access                 = "Deny"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = tostring(security_rule.value)
      source_address_prefix  = "*"
      destination_address_prefix = "*"
    }
  }

  tags = merge(local.tags, var.tags)
}

resource "azurerm_network_interface" "edgemanager_nic" {
  name                = "${var.name}-nic"
  location            = data.azurerm_location.default.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.name}-nic-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = var.address_allocation
  }

  tags = merge(local.tags, var.tags)
}

resource "azurerm_network_interface_security_group_association" "edgemanager_association" {
  network_interface_id      = azurerm_network_interface.edgemanager_nic.id
  network_security_group_id = azurerm_network_security_group.edgemanager_nsg.id
}
