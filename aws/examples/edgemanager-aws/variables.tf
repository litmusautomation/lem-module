variable "ami_owner" {
  description = "The AWS account ID that owns the AMI."
  type        = string
}

variable "app_version" {
  description = "The application version to be deployed."
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair used for VM access."
  type        = string
}

variable "name" {
  description = "The identifier assigned to resources for easier management."
  type        = string
}

variable "region" {
  description = "The AWS region where resources will be deployed."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the target subnet where the virtual machine will be deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the target VPC where the virtual machine will be deployed."
  type        = string
}

# -- Optional variables --

variable "admin_user_name" {
  description = "The admin user account to be created on the virtual machine."
  type        = string
  default     = "ubuntu"
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

variable "ingress_tcp_ports" {
  description = "List of TCP ports to allow ingress traffic. Minimum required: 443."
  type        = list(number)
  default     = [80, 443, 8883, 9092, 8446, 9093, 8123, 8543, 9000, 9004, 9090]
}

variable "ingress_udp_ports" {
  description = "List of UDP ports to allow ingress traffic. Minimum required: 51820."
  type        = list(number)
  default     = [51820, 123]
}

variable "oem_name" {
  description = "The OEM name associated with the virtual machine."
  type        = string
  default     = "edgemanager"
}

variable "ssh_enabled" {
  description = "Enable SSH access to the virtual machine. When false, no key pair is attached and port 22 is not opened."
  type        = bool
  default     = false
}

variable "ssh_pub_key" {
  description = "The user-defined public SSH key added to the virtual machine for access."
  type        = string
  sensitive   = true
  default     = ""
}
