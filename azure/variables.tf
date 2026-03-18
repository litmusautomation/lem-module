variable "admin_user_name" {
  type        = string
  description = "The administrator username for the VM."
  default     = "ubuntu"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID where resources will be deployed."
  sensitive   = true
}

variable "app_version" {
  type        = string
  description = "The version of Edgemanager to deploy."
}

variable "image_resource_group_name" {
  type        = string
  description = "The name of the resource group where the VM image is stored."
}

variable "ingress_cidr_blocks" {
  description = "A list of CIDR blocks allowed to access the instance."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_cidr_ssh_blocks" {
  description = "A list of CIDR blocks allowed SSH access to the instance."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed."
}

variable "name" {
  type        = string
  description = "The name of the Azure resource."
}

variable "oem_name" {
  type        = string
  description = "The name of the OEM associated with the Edgemanager deployment."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group."
}

variable "ssh_pub_key" {
  type        = string
  sensitive   = true
  description = "The SSH public key for remote access to the VM. Required by the Azure provider regardless of ssh_enabled."
}

variable "ssh_enabled" {
  type        = bool
  description = "Enable SSH access to the virtual machine. When false, port 22 is explicitly denied in the NSG."
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "The name of the Azure subnet where the VM will be deployed."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the Azure virtual network."
}

variable "ingress_tcp_ports" {
  description = "List of TCP ports to allow ingress traffic. Minimum required: 443."
  type        = list(number)
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
  description = "List of UDP ports to allow ingress traffic. Minimum required: 51820."
  type        = list(number)
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
