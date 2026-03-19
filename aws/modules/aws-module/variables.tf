variable "admin_user_name" {
  type        = string
  description = "The administrator username for the virtual machine."
}

variable "ami_owner" {
  type        = string
  description = "The AWS account ID of the AMI owner."
}

variable "image_version" {
  type        = string
  description = "The version of the AMI image to use for deployment."
}

variable "name" {
  type        = string
  description = "A name applied to resources for easier identification."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the target subnet in which the virtual machine will be deployed."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in which the virtual machine will be deployed."
}

# -- Optional variables --

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

variable "key_name" {
  type        = string
  description = "The name of the SSH key pair used for VM access. Required when ssh_enabled = true."
  default     = null
}

variable "private_ip" {
  type        = string
  description = "A dedicated, preassigned private IP to be used by the virtual machine."
  default     = null
}

variable "ssh_enabled" {
  type        = bool
  description = "Enable SSH access to the virtual machine. When false, no key pair is attached and port 22 is not opened in the security group."
  default     = false

  validation {
    condition     = !var.ssh_enabled
    error_message = "SSH access is not supported on Edge Manager deployments. ssh_enabled must be false."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to resources."
  default     = {}
}

variable "user_data" {
  type        = string
  description = "User defined custom data."
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "The instance type (VM size) to be used for deployment."
  default     = "t3.xlarge"
}
