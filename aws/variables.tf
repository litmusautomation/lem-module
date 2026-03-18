variable "admin_user_name" {
  description = "The admin user account to be created on the virtual machine."
  type        = string
  default     = "ubuntu"
}

variable "region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "app_version" {
  description = "The application version to be deployed."
  type        = string
}

variable "ami_owner" {
  description = "The AWS account ID that owns the AMI."
  type        = string
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

variable "key_name" {
  description = "The name of the SSH key pair used for VM access. Required when ssh_enabled = true."
  type        = string
  default     = null
}

variable "ssh_enabled" {
  description = "Enable SSH access to the virtual machine. When false, no key pair is attached and port 22 is not opened."
  type        = bool
  default     = false
}

variable "name" {
  description = "The identifier assigned to resources for easier management."
  type        = string
}

variable "oem_name" {
  description = "The OEM name associated with the virtual machine."
  type        = string
  default     = "edgemanager"
}

variable "ssh_pub_key" {
  description = "The user-defined public SSH key added to the virtual machine for access."
  type        = string
  sensitive   = true
  default     = ""
}

variable "subnet_id" {
  description = "The ID of the target subnet where the virtual machine will be deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the target VPC where the virtual machine will be deployed."
  type        = string
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
