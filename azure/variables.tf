variable "admin_user_name" {
  type        = string
  description = "The administrator username for the VM."
  default     = "ubuntu"
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
  default     = []
}

variable "ingress_cidr_ssh_blocks" {
  description = "A list of CIDR blocks allowed SSH access to the instance."
  type        = list(string)
  default     = []
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
  description = "The SSH public key for user-defined remote access to the VM."
}

variable "subnet_id" {
  type        = string
  description = "The Azure subnet ID where the VM will be deployed."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the Azure virtual network."
}
