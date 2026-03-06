variable "address_allocation" {
  type        = string
  description = "The method of IP address allocation for the VM (e.g., Dynamic or Static)."
  default     = "Dynamic"
}

variable "admin_user_name" {
  type        = string
  description = "The administrator username for the virtual machine."
}

variable "custom_data" {
  type        = string
  description = "User defined custom data."
  default     = ""
}

variable "custom_ssh_pub_key" {
  type        = string
  description = "A user-defined SSH public key used to allow remote access to the virtual machine."
}

variable "image_resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the image."
}

variable "image_version" {
  type        = string
  description = "The version of the image to use for the virtual machine."
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "A list of IPv4 CIDR ranges to be used for all ingress rules except SSH."
  default     = ["0.0.0.0/0"]
}

variable "ingress_cidr_ssh_blocks" {
  type        = list(string)
  description = "A list of CIDR blocks allowed to SSH into the virtual machine."
  default     = ["0.0.0.0/0"]
}

variable "location" {
  type        = string
  description = "The Azure location where resources will be deployed."
}

variable "name" {
  description = "The identifier assigned to resources for easier management."
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group."
  default     = "undefined"
}

variable "subnet_id" {
  type        = string
  description = "The name of the subnet to which the virtual machine will be connected."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to resources."
  default     = {}
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network where the VM will be deployed."
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machine instance."
  default     = "Standard_B4ms"
}

variable "ingress_tcp_ports" {
  type        = list(number)
  description = "List of TCP ports to allow ingress traffic. Minimum required: 443."
  default = [
    80, 443, 8883,
    9092, 8446, 9093,
    8123, 8543, 9000,
    9004, 9090,
  ]

  validation {
    condition     = !contains(var.ingress_tcp_ports, 22)
    error_message = "SSH port 22 is not allowed for security reasons. SSH access is disabled on Edge Manager deployments."
  }

  validation {
    condition     = contains(var.ingress_tcp_ports, 443)
    error_message = "Port 443 (HTTPS) is required for Litmus Edge Manager functionality."
  }

  validation {
    condition     = alltrue([for port in var.ingress_tcp_ports : port >= 1 && port <= 65535])
    error_message = "All TCP ports must be between 1 and 65535."
  }
}

variable "ingress_udp_ports" {
  type        = list(number)
  description = "List of UDP ports to allow ingress traffic. Minimum required: 51820."
  default     = [51820, 123]

  validation {
    condition     = contains(var.ingress_udp_ports, 51820)
    error_message = "Port 51820 (WireGuard VPN) is required for Litmus Edge Manager functionality."
  }

  validation {
    condition     = alltrue([for port in var.ingress_udp_ports : port >= 1 && port <= 65535])
    error_message = "All UDP ports must be between 1 and 65535."
  }
}
