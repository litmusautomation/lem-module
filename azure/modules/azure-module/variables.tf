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
  description = "The ID of the subnet to which the virtual machine will be connected."
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
