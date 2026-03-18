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

variable "ssh_enabled" {
  type        = bool
  description = "Enable SSH access to the virtual machine. When false, port 22 is explicitly denied in the NSG."
  default     = false
}

variable "ssh_pub_key" {
  type        = string
  sensitive   = true
  description = "The SSH public key for user-defined remote access to the VM."
}

variable "subnet_name" {
  type        = string
  description = "The name of the Azure subnet where the VM will be deployed."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the Azure virtual network."
}
